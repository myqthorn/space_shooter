class_name Tesla extends CharacterBody2D

signal tesla_destroyed
@export var direction = Vector2(0,0)
@export var speed = 0.0
@export var angular_velocity = 0.0
@export var HP = 1000
@export var damage = 100
@export var wrap_around = true
@export var point_value = 150
var screen_size

func _ready():
	if direction == Vector2(0,0):
		direction.x = randf_range(-1.0,1.0)
		direction.y = randf_range(-1.0,1.0)

	if speed == 0:
		speed = randf_range(10,100)

	if angular_velocity == 0:
		angular_velocity = randf_range(-1.0, 1.0)
	screen_size = get_viewport_rect().size
	var x = randi_range(0.1 * screen_size.x, 0.9 * screen_size.x)
	var y = randi_range(0.1 * screen_size.y, 0.9 * screen_size.y)
	position = Vector2(x,y)

func _process(delta):
	screen_size =  get_viewport_rect().size
	rotate(delta * angular_velocity)
	position += delta * direction * speed
	wraparound()

func take_damage(value):
	HP -= value
	print("Tesla HP:", HP)
	if HP <= 0:
		die()

func die():
	queue_free()
	print("Tesla die")
	tesla_destroyed.emit(point_value)

func _on_area_2d_area_entered(_area):
	#if area.get_parent() is Player:
		#area.get_parent().die
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_body_entered(body):
	if body is Player:
		body.take_damage(damage)
		take_damage(body.damage)
		
func wraparound():
	if wrap_around:
		position.x = wrapf(position.x, -200, screen_size.x + 200)
		position.y = wrapf(position.y, -200, screen_size.y + 200)
