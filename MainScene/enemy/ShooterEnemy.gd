extends Enemy
class_name ShooterEnemy

onready var fireTimer := $FireTimer

export var fireRate := 3.0

func _process(delta):
	if fireTimer.is_stopped():
		fire()
		fireTimer.start(fireRate)
