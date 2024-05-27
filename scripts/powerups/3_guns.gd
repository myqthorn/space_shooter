class_name ThreeGuns extends Powerup


func _ready():
	super._ready()
	assignHudImage($HUDImage)
	end_powerup.connect(func(): parent.num_guns=1)
	

func begin():
	print("3 guns begin")
	super.begin()
	parent.num_guns = 3
	

