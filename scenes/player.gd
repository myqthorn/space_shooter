extends CharacterBody2D
class_name Player

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
@onready var gun1 = $gun1
@onready var gun2 = $gun2
@onready var gun3 = $gun3
#var velocity
var direction = Vector2(0,0)
var cur_angle = PI / 2

var vel = 0.0
var rot = 0.0

var laser_scene = preload("res://scenes/laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	show()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handle_inputs()
	move_and_slide()
	wraparound()
	handle_animations()

func handle_inputs():
	var angle = Input.get_axis("move_left", "move_right")
	vel = Input.get_axis("move_up", "move_down")
	if Input.is_action_just_pressed("hyperspace"):
		hyperspace()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	rotation_angle += angle * 0.1
	rotation = rotation_angle
	direction = Vector2.from_angle(rotation_angle + (PI / 2))
	velocity += direction * vel * speed


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

func hyperspace():
	var size = get_viewport_rect().size
	var x = randi_range(0.1 * size.x, 0.9 * size.x)
	var y = randi_range(0.1 * size.y, 0.9 * size.y)
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
	
func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	print("Player Collision")

func die():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	cur_angle = PI / 2
	velocity = Vector2(0.0,0.0)

func wraparound():
	var size = get_viewport_rect().size
	if wrap_around:
		position.x = wrapf(position.x, 0, size.x)
		position.y = wrapf(position.y, 0, size.y)
