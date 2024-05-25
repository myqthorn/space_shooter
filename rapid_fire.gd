class_name RapidFire extends Powerup



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print("rapid fire")
	

func _begin():
	super.begin()
	parent.shoot_cooldown_time = .2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
