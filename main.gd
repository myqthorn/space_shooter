extends Node2D

@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
var player = null
var score = 0
var tesla_scene = preload("res://scenes/tesla.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("playerGroup")
	$PlayerSpawnPosition.position = get_viewport_rect().get_center()
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	
	var tesla = tesla_scene.instantiate()
	enemy_container.add_child(tesla)
	score = 0
	tesla.tesla_destroyed.connect(_on_tesla_destroyed)
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	$CanvasLayer/HealthBar.max_value = $player.HP_max
	$CanvasLayer/TextureHealthBar.max_value = $player.HP_max
	$CanvasLayer/HealthBar.value = $player.HP
	$CanvasLayer/TextureHealthBar.value = $player.HP
	$CanvasLayer/Score.text =str(score)
	
func _on_player_laser_shot(laser_scene, location, angle):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser.direction = Vector2.from_angle(angle - (PI / 2))
	laser.rotation = angle
	laser_container.add_child(laser)

func _on_tesla_destroyed(points):
	score += points
	
