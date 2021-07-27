extends Area2D
class_name Meteor

export var minSpeed: float = 20
export var maxSpeed: float = 40
export var minRotationRate: float = -20
export var maxRotationRate: float = 20
export var life: int = 30

var speed: float = 0
var rotationRate: float = 0
var playerInArea: Player = null
var pMeteorEffect:= preload("res://MainScene/MeteorEffect.tscn")

func _ready():
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	
func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)
	
func _physics_process(delta):
	position.y += speed * delta
	rotation_degrees += rotationRate * delta

func damage(amount: int):
	# Double point bug fix
	if life <= 0:
		return;
	
	life -= amount
	
	if life <= 0:
		var effect := pMeteorEffect.instance()
		effect.position = position
		get_parent().add_child(effect)
		Signals.emit_signal("on_score_increment", 20)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Meteor_area_entered(area):
	if area is Player:
		playerInArea = area

func _on_Meteor_area_exited(area):
	if area is Player:
		playerInArea = null
