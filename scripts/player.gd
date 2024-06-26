class_name Player extends CharacterBody2D


signal hit
signal laser_shot(laser_scene, location, angle)

@export var speed = 50 # How fast the player will move (pixels/sec).
@export var acceleration = 0.1

@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_down = "move_down"
@export var move_up = "move_up"
@export var offset = Vector2.ZERO
@export var rotation_angle = PI / 64
@export var num_guns = 1
@export var wrap_around = true
@export var power_up = false
var default_shoot_cooldown_time = 0.5
@export var shoot_cooldown_time = 0.5
@export var invincibility_frame_time = 2
@onready var invincible = false
@export var damage = 100
@export var HP = 1200
@export var HP_max = 1200

@onready var gun1 = $gun1
@onready var gun2 = $gun2
@onready var gun3 = $gun3
@onready var main = $".."
#var velocity
var direction = Vector2(0,0)
var cur_angle = PI / 2

var vel = 0.0
var rot = 0.0

var laser_scene = preload("res://scenes/laser.tscn")

var available_powerups = [
	preload("res://scenes/powerups/death_blossom.tscn"),
	preload("res://scenes/powerups/3_guns.tscn"),
	preload("res://scenes/powerups/rapid_fire.tscn"),
	preload("res://scenes/powerups/shield.tscn"),
	]
var powerup_scene
@export var powerup_max_time = 1.0
@export var powerup_time_remaining = 0.0

var shoot_cooldown := false
var health_bar_timeout = 2.0
var powerup_list

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	show()
	#for item in available_powerups:		
		#powerup_scene = item.instantiate()
		#$PowerupContainer.add_child(powerup_scene)
	
		

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	handle_inputs()
	var collision_info = move_and_collide((velocity * delta))
	if collision_info:
		handle_collision(collision_info)
	
	wraparound()
	handle_animations()


func handle_inputs():
	var angle = Input.get_axis("move_left", "move_right")
	vel = Input.get_axis("move_up", "move_down")
	if angle || vel:
		if !$Thrust.playing:
			$Thrust.play()
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
	velocity += direction * vel * speed * acceleration

	if Input.is_action_just_pressed("powerup"):
		activate_powerup()


func handle_collision(collision_info):
	velocity = velocity.bounce(collision_info.get_normal())
	var object = collision_info.get_collider()
	if object is Tesla:
		object.take_damage(damage)
		take_damage(object.damage)
	if object is LoosePowerUp:
		add_random_power_up()
	if object is Player:
		object.take_damage(damage)
		take_damage(object.damage)
		print("i hit my other player")
	if (object is SpaceJunk) || (object.get_parent() is SpaceJunk):
		object.take_damage(damage)
		take_damage(object.damage)
		print("player hit spacejunk")

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
	
		
func activate_powerup():
	powerup_list = $PowerupContainer.get_children()
	if powerup_list && powerup_list[0]:
		if !powerup_list[0].is_powerup_active && !powerup_list[0].is_passive:
			powerup_list[0].begin()
			set_next_hud_powerup()
			#connect(powerup_list[0].powerup_time_left, on_time_left)
		

func set_next_hud_powerup():
	print("set_next_hud_powerup")
	powerup_list = $PowerupContainer.get_children()
	print("powerup_list", powerup_list)
	var powerup_found = false
	for powerup in powerup_list:
		if !powerup.is_queued_for_deletion():
			print(powerup, powerup.is_powerup_active, powerup.is_passive)
			main.AssignHUDImage(powerup.hud_image.texture)
			if !powerup.is_powerup_active:
				on_time_left(1,1)
			print("connect on_time_left to powerup: ", powerup)
			powerup.powerup_time_left.connect(on_time_left)
			powerup_found = true
			break
	if !powerup_found:
		on_time_left(0,1)
		main.AssignHUDImage(null)
			
func hyperspace():
	var x = randi_range(0.1 * get_parent().screen_size.x, 0.9 * get_parent().screen_size.x)
	var y = randi_range(0.1 * get_parent().screen_size.y, 0.9 * get_parent().screen_size.y)
	#TODO: check for collision
	
	
	
	#TODO: set timer
	position = Vector2(x,y)
	velocity = Vector2(0,0)
	
func shoot():
	laser_shot.emit(laser_scene, gun1.global_position, rotation_angle)
	if num_guns > 1:
		laser_shot.emit(laser_scene, gun2.global_position, rotation_angle)
	if num_guns > 2:
		laser_shot.emit(laser_scene, gun3.global_position, rotation_angle)

func take_damage(value):
	if !invincible:
		HP -= value
		print("Player HP:", HP)
		if HP <= 0:
			die()
		else:
			invincible = true
			get_tree().create_timer(invincibility_frame_time).timeout
			invincible = false
func die():
	position = Vector2(get_parent().screen_size.x/2, get_parent().screen_size.y/2)
	cur_angle = PI / 2
	velocity = Vector2(0.0,0.0)
	HP = HP_max
	print("Player die")

func wraparound():
	if wrap_around:
		position.x = wrapf(position.x, 0, get_parent().screen_size.x)
		position.y = wrapf(position.y, 0, get_parent().screen_size.y)


func on_time_left(time_left, max_val):
	print("on_time_left", time_left, ", ", max_val)
	powerup_time_remaining = time_left
	powerup_max_time = max_val


func add_random_power_up():
	var index = randi_range(0, available_powerups.size() - 1)
	powerup_scene = available_powerups[index].instantiate()
	
	$PowerupContainer.add_child(powerup_scene)
	set_next_hud_powerup()
	powerup_scene.end_powerup.connect(set_next_hud_powerup)
	
	if powerup_scene.is_passive:
		powerup_scene.begin()


func add_power_up(type):
	if type <= available_powerups.size():
		powerup_scene = available_powerups[type].instantiate()
		$PowerupContainer.add_child(powerup_scene)

func reset_shoot_cooldown_time():
	shoot_cooldown_time = default_shoot_cooldown_time
