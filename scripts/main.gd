extends Node2D

@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
var player = null
var score = 0
var tesla_scene = preload("res://scenes/tesla.tscn")
var loose_power_up_scene = preload("res://scenes/loose_power_up.tscn")
@export var screen_size: Vector2 = get_viewport_rect().size

func _ready():
	screen_size =  get_viewport_rect().size
	player = get_tree().get_first_node_in_group("playerGroup")
	$PlayerSpawnPosition.position = get_viewport_rect().get_center()
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	
	var tesla = tesla_scene.instantiate()
	enemy_container.add_child(tesla)
	score = 0
	tesla.tesla_destroyed.connect(_on_tesla_destroyed)

	#testing
	var pu = loose_power_up_scene.instantiate()
	add_child(pu)
	#pu.attained.connect(loose_pu_attained, player)
	
	
	
func _process(_delta):
	screen_size =  get_viewport_rect().size
	handle_inputs()
	handle_gui()

func _on_player_laser_shot(laser_scene, location, angle):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser.direction = Vector2.from_angle(angle - (PI / 2))
	laser.rotation = angle
	laser_container.add_child(laser)

func _on_tesla_destroyed(points):
	score += points
	

func handle_inputs():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func handle_gui():
	$CanvasLayer/TextureHealthBar.max_value = $player.HP_max
	$CanvasLayer/TextureHealthBar.value = $player.HP
	$CanvasLayer/Score.text =str(score)
	$CanvasLayer/PowerUpDurationBar.value = $player.powerup_time_remaining * 100
	$CanvasLayer/PowerUpDurationBar.max_value = $player.powerup_max_time * 100
	

#func loose_pu_attained(player):
	#player.add_random_power_up()
	
	

