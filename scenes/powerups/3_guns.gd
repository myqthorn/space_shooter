class_name ThreeGuns extends Powerup


func _ready():
	super._ready()
	powerup_duration = 4.0

func begin():
	super.begin()
	parent.num_guns = 3

func start_duration_timer():
	print("PU setup_duration_timer")
	duration_timer = get_tree().create_timer(powerup_duration)
	await duration_timer.timeout
	parent.num_guns = 1
	queue_free()
