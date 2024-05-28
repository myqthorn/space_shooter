class_name Laser extends Area2D

@export var direction = Vector2(0.0, 0.0 )
@export var speed = 600
@export var damage = 100
@export var finish_sound_duration = 0.5
@onready var sound = $Straw1

func _ready():
	$Sprite2D.show()
	sound.play()

func _physics_process(delta):
	global_position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	$Sprite2D.hide()
	await get_tree().create_timer(finish_sound_duration).timeout
	queue_free()





func _on_body_entered(body):
	if body is Tesla:		
		body.take_damage(damage)
		die()
	if body is SpaceJunk:
		body.take_damage(damage)
		die()

func set_sound_to_straw():
	sound = $Straw1
	

func set_sound_to_chirp():
	sound = $Chirp

func die():
	$Sprite2D.hide()
	await get_tree().create_timer(finish_sound_duration).timeout
	queue_free()
