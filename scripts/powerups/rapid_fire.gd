class_name RapidFire extends Powerup



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("rapid fire")
	assignHudImage($HUDImage)
	end_powerup.connect(parent.reset_shoot_cooldown_time)

func begin():
	super.begin()
	parent.shoot_cooldown_time = 0.16
	print("rapid fire begin")

