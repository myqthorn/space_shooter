class_name Powerup extends Node2D

signal powerup_time_left

var is_powerup_active = false
var parent
@export var powerup_duration = 1.0
var duration_timer = 0
@export var is_passive = false
var hud_image

enum powerup_type {
	Powerup_Death_Blossom,
	Powerup_3_Guns,
	Powerup_Rapid_Fire,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("PU Ready")
	parent = get_parent().get_parent()
	is_powerup_active = false
	hud_image = $HUDImage

func _process(_delta):
	if is_powerup_active && duration_timer:
		#emit_signal("powerup_time_left", duration_timer.time_left, powerup_duration )
		powerup_time_left.emit(duration_timer.time_left, powerup_duration)

func begin():
	print("PU setup")
	if !is_powerup_active:
		#var main = parent.get_parent()
		#parent.connect("powerup_time_left", parent.on_time_left)
		#print("connect")
		is_powerup_active = true
		start_duration_timer()

func start_duration_timer():
	print("PU setup_duration_timer")
	duration_timer = get_tree().create_timer(powerup_duration)
	await duration_timer.timeout
	is_powerup_active = false
	queue_free()
	
func assignHudImage(image):
	hud_image = image
	
