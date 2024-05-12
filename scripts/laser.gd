extends Area2D

@export var direction = Vector2(0.0, 0.0 )
@export var speed = 600
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
