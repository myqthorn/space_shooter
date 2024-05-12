extends Area2D
class_name Player

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size
@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_down = "move_down"
@export var move_up = "move_up"
@export var offset = Vector2.ZERO
@export var rotation_angle = PI / 64
var velocity

var cur_angle = PI / 2

var vel = 0.0
var rot = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2
	position.y = screen_size.y/2
	#hide()
	show()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_inputs()
	move_player(delta)
	handle_animations()

func handle_inputs():	
	rot = Input.get_axis("ui_left", "ui_right")
	if rot == 0.0:
		if Input.is_action_pressed(move_right):
			rot += 1
		if Input.is_action_pressed(move_left):
			rot -= 1
	vel = Input.get_axis("ui_up", "ui_down")
	if vel == 0.0:
		if Input.is_action_pressed(move_down):
			vel += 1
		if Input.is_action_pressed(move_up):
			vel -= 1
	
	
func move_player(delta):
	cur_angle += rot * rotation_angle
	velocity = Vector2.from_angle(cur_angle)
	if vel != 0:
		velocity = velocity.normalized() * speed * vel
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	#position = position.clamp(offset, screen_size+offset)
	rotation = cur_angle - PI/2
	
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

func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func die():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	cur_angle = PI / 2
	velocity = 0
