class_name Player extends CharacterBody2D


signal hit
signal laser_shot(laser_scene, location, angle)

@export var speed = 10 # How fast the player will move (pixels/sec).
var screen_size
@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_down = "move_down"
@export var move_up = "move_up"
@export var offset = Vector2.ZERO
@export var rotation_angle = PI / 64
@export var three_guns = false
@export var wrap_around = true
@export var power_up = false
@export var shoot_cooldown_time = 0.25
@export var damage = 100
@export var HP = 1200
@export var HP_max = 1200

@onready var gun1 = $gun1
@onready var gun2 = $gun2
@onready var gun3 = $gun3

#var velocity
var direction = Vector2(0,0)
var cur_angle = PI / 2

var vel = 0.0
var rot = 0.0

var laser_scene = preload("res://scenes/laser.tscn")
var health_bar = preload("res://scenes/health_bar.tscn")
var health_bar_scene
var shoot_cooldown := false
var health_bar_timeout = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	show()
	health_bar_scene = health_bar.instantiate()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	screen_size =  get_viewport_rect().size
	handle_inputs()
	#move_and_slide()
	#var collision_info = move_and_collide((velocity * delta), false,0.00,true)
	handle_powerups(delta)
	var collision_info = move_and_collide((velocity * delta))
	if collision_info:
		handle_collision(collision_info)
	
	wraparound()
	handle_animations()

func handle_inputs():
	var angle = Input.get_axis("move_left", "move_right")
	vel = Input.get_axis("move_up", "move_down")
	if Input.is_action_just_pressed("hyperspace"):
		hyperspace()
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot()
			await get_tree().create_timer(shoot_cooldown_time).timeout
			shoot_cooldown = false
	rotation_angle += angle * 0.1
	rotation = rotation_angle
	direction = Vector2.from_angle(rotation_angle + (PI / 2))
	velocity += direction * vel * speed

	if Input.is_action_pressed("powerup"):
		power_up = true
		shoot()
		await get_tree().create_timer(2).timeout
		power_up = false
func handle_collision(collision_info):
	velocity = 0.5 * velocity.bounce(collision_info.get_normal())
	var object = collision_info.get_collider()
	if object is Tesla:
		object.take_damage(damage)
		take_damage(object.damage)
		
	
	print("bounce")
	
func handle_animations():
	if velocity == Vector2(0,0):
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play("",2.0)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.flip_v = velocity.y > 0
func handle_powerups(delta):
	if power_up:
		rotation_angle += delta * 50
		await get_tree().create_timer(.25).timeout
		shoot()
		
func hyperspace():
	var x = randi_range(0.1 * screen_size.x, 0.9 * screen_size.x)
	var y = randi_range(0.1 * screen_size.y, 0.9 * screen_size.y)
	#TODO: check for collision
	#TODO: set timer
	position = Vector2(x,y)
	velocity = Vector2(0,0)
	
func shoot():
	laser_shot.emit(laser_scene, gun1.global_position, rotation_angle)
	if three_guns:
		laser_shot.emit(laser_scene, gun2.global_position, rotation_angle)
		laser_shot.emit(laser_scene, gun3.global_position, rotation_angle)
	three_guns = !three_guns
	#
#func _on_body_entered(_body):
	#hide() # Player disappears after being hit.
	#hit.emit()
	## Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	#print("Player Collision")

func take_damage(value):
	HP -= value
	print("Player HP:", HP)
	if HP <= 0:
		die()
	else:
		#health_bar_scene.$ProgressBar.value = HP
		#health_bar_scene.max_value = HP_max
		health_bar_scene
		health_bar_scene.show()
		
		
		
func die():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	cur_angle = PI / 2
	velocity = Vector2(0.0,0.0)
	print("Player die")

func wraparound():
	if wrap_around:
		position.x = wrapf(position.x, 0, screen_size.x)
		position.y = wrapf(position.y, 0, screen_size.y)
