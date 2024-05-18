class_name LoosePowerUp extends CharacterBody2D

signal attained

@export var wrap_around = true
var direction
var direction_timer
var target_location = Vector2(0,0)
const SPEED = 50.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	show()
	$Hexagon.play("default")
	direction_timer = get_tree().create_timer(1.0)
	
func _physics_process(delta):
	$Hexagon.rotate(delta)
	
	get_direction()	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	wraparound()	

func get_direction():
	await direction_timer.timeout
	direction_timer = get_tree().create_timer(1.0)
	direction = Vector2(randf_range(-3,3), randf_range(-3,3))


func wraparound():
	if wrap_around:
		position.x = wrapf(position.x, 0, get_parent().screen_size.x)
		position.y = wrapf(position.y, 0, get_parent().screen_size.y)


func _on_body_entered(body):
	print("body_entered")
	if body is Player:
		body.add_random_power_up()
		print("powered up!")
