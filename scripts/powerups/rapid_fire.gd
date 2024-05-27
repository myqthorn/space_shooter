class_name RapidFire extends Powerup



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("rapid fire")
	assignHudImage($HUDImage)

func begin():
	super.begin()
	parent.shoot_cooldown_time = 0.16
	print("rapid fire begin")

func start_duration_timer():
	print("rapid fire PU setup_duration_timer")
	duration_timer = get_tree().create_timer(powerup_duration)
	await duration_timer.timeout
	parent.reset_shoot_cooldown_time()
	queue_free()
