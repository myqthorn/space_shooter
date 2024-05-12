extends Node2D
@export var direction = Vector2(0,0)
@export var speed = 0.0
@export var angular_velocity = 0.0

func _ready():
	if direction == Vector2(0,0):
		direction.x = randf_range(-1.0,1.0)
		direction.y = randf_range(-1.0,1.0)

	if speed == 0:
		speed = randf_range(10,100)

	if angular_velocity == 0:
		angular_velocity = randf_range(-1.0, 1.0)

func _process(delta):
	rotate(delta * angular_velocity)
	position += delta * direction * speed


func _on_area_2d_area_entered(_area):
	#if area.get_parent() is Player:
		#area.get_parent().die
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
