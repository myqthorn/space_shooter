class_name Shield extends Powerup


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("shield")
	assignHudImage($HUDImage)
	end_powerup.connect(func(): parent.num_guns=1)
	

func begin():
	super.begin()
	parent.shoot_cooldown_time = 0.16
	print("rapid fire begin")

