extends Area2D

export var speed: float = 500

var pBulletEffect := preload("res://MainScene/EnemyBulletEffect.tscn")

func _physics_process(delta):
	position.y += speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area):
	if area is Player:
		var bulletEffect = pBulletEffect.instance()
		bulletEffect.global_position = global_position
		get_parent().add_child(bulletEffect)
		area.damage(1)
		queue_free()
