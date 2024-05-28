class_name SpaceJunk extends CharacterBody2D

signal destroyed
@export var direction = Vector2(0,0)
@export var speed = 200.0
@export var HP = 100
@export var damage = 100
@export var wrap_around = true
@export var point_value = 150
@export var angular_velocity = 0.0

func _ready():
	pick_position()
	if angular_velocity == 0:
		angular_velocity = randf_range(-1.0, 1.0)
	if velocity == Vector2(0,0):
		velocity.x = randf_range(-1.0,1.0)
		velocity.y = randf_range(-1.0,1.0)
	
func _physics_process(delta):
	rotate(delta * angular_velocity)
	var collision_info = move_and_collide((velocity * delta * speed))
	if collision_info:
		handle_collision(collision_info)
	wraparound()

func take_damage(value):
	HP -= value
	print("Spacejunk HP:", HP)
	if HP <= 0:
		die()

func die():
	print("spacejunk die")
	destroyed.emit(point_value)
	queue_free()
	
#func _on_body_entered(body):
	#if body is Player:
		#body.take_damage(damage)
		#take_damage(body.damage)
		#print("spacejunk hit player")
		
	#if body is Laser:
		#take_damage(body.damage)	
		#body.disappear()

func wraparound():
	if wrap_around:
		position.x = wrapf(position.x, 0,  get_parent().screen_size.x)
		position.y = wrapf(position.y, 0,  get_parent().screen_size.y)

func pick_position():
	position.x = randi_range(0, get_parent().screen_size.x)
	position.y = randi_range(0, get_parent().screen_size.y)
	#angular_velocity = 3


func handle_collision(collision_info):
	velocity = velocity.bounce(collision_info.get_normal())
	var object = collision_info.get_collider()
	if object is Tesla:
		object.take_damage(damage)
		take_damage(object.damage)
	if object is Player:
		print(object.velocity)
		object.velocity = object.velocity.bounce(collision_info.get_normal())
		print(object.velocity)
		object.take_damage(damage)
		take_damage(object.damage)
		print("spacejunk hit player")
	if object is SpaceJunk:
		object.take_damage(0.2 * damage)
		take_damage(0.2 * object.damage)
		print("spacejunk hit spacejunk")
	if object is Laser:
		take_damage(object.damage)	
		object.die()
		print("spacejunk hit laser")
