class_name DeathBlossom extends Powerup



func _ready():
	super._ready()
	assignHudImage($HUDImage)

func begin():
	super.begin()
	print("DB begin")
	$ActionTimer.start()


func _on_action_timer_timeout():
	parent.rotation_angle += 2 + randf()
	parent.shoot()	
