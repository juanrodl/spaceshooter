extends Area2D
class_name Enemy

var plBullet := preload("res://MainScene/EnemyBullet.tscn")
var plEnemyExplosion := preload("res://MainScene/enemy/EnemyExplosion.tscn")

onready var firingPositions = $FiringPositions
onready var laserSFX = $LaserSFX

export var verticalSpeed: float = 5
export var life: float = 10

var playerInArea: Player = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += verticalSpeed

func damage(amount: int):
	# Double point bug fix
	if life <= 0:
		return;

	life -= amount
	if life <= 0:
		var effect = plEnemyExplosion.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)	
		Signals.emit_signal("on_score_increment", 10)
		queue_free()

		
func fire():
	for child in firingPositions.get_children():
		var bullet := plBullet.instance()
		bullet.global_position = child.global_position
		get_tree().current_scene.add_child(bullet) 
		laserSFX.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_area_entered(area):
	if area is Player:
		playerInArea = area

func _on_Enemy_area_exited(area):
	if area is Player:
		playerInArea = null
	
