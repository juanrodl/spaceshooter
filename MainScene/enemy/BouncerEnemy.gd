extends ShooterEnemy

export var horizontalSpeed := 50

var horizontalDir : int = 1

func _physics_process(delta):
	position.x += horizontalSpeed * delta * horizontalDir
	
	var viewRect = get_viewport_rect()
	if position.x < viewRect.position.x or position.x > viewRect.end.x:
		horizontalDir *= -1
