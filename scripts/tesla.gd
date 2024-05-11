extends Node2D
@export var direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	direction.x = randf()
	direction.y = randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(delta * .1)
	position += delta * direction * 10
