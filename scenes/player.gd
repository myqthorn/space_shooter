extends CharacterBody2D
class_name Player

signal hit

@export var speed = 10 # How fast the player will move (pixels/sec).
var screen_size
@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_down = "move_down"
@export var move_up = "move_up"
@export var offset = Vector2.ZERO
@export var rotation_angle = PI / 64
#var velocity
var direction = Vector2(0,0)
var cur_angle = PI / 2

var vel = 0.0
var rot = 0.0
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
	handle_animations()

func handle_inputs():
	var angle = Input.get_axis("move_left", "move_right")
	vel = Input.get_axis("move_up", "move_down")
	if Input.is_action_just_pressed("hyperspace"):
		hyperspace()
	
	
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
