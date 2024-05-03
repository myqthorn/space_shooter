extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@export var move_left = "move_left"
@export var move_right = "move_right"
@export var move_down = "move_down"
@export var move_up = "move_up"
@export var offset = Vector2.ZERO
@export var rotation_angle = PI / 64

var cur_angle = PI / 2
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
	var vel = 0
	var rot = 0
	if Input.is_action_pressed(move_right):
		rot += 1
	if Input.is_action_pressed(move_left):
		rot -= 1
	if Input.is_action_pressed(move_down):
		vel += 1
	if Input.is_action_pressed(move_up):
		vel -= 1
	cur_angle += rot * rotation_angle
	var velocity = Vector2.from_angle(cur_angle)
	
	if vel != 0:
		velocity = velocity.normalized() * speed * vel
		$AnimatedSprite2D.play("",2.0)
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	#position = position.clamp(offset, screen_size+offset)
	rotation = cur_angle - PI/2
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
