extends Area2D
class_name Player

onready var animatedSprite := $AnimatedSprite
onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibiltyTimer
onready var shieldSprite := $Shield
onready var laserSFX := $LaserSFX
onready var damageTakenSFX := $DamageTakenSFX

var plBullet := preload("res://MainScene/Bullet.tscn")

export var speed: float = 100
export var fireDelay: float = 0.1
export var damageInvincibilityTime: float = 2
export var lives: int = 3
var vel := Vector2(0,0)
	
func _ready():
	shieldSprite.visible = false 	
	Signals.emit_signal("on_player_life_change", lives)
	
func _process(delta):
	if vel.x < 0:
		animatedSprite.play("Left")
	elif vel.x > 0:
		animatedSprite.play("Right")
	else:
		animatedSprite.play("Straight")
		
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		
		fireDelayTimer.start(fireDelay)
		laserSFX.play()
		
		for child in firingPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet) 	
	
func _physics_process(delta):
	var dirVec := Vector2(0,0)
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
	
	vel = dirVec.normalized() * speed
	position += vel * delta
	
	# Make sure we are within screen
	var viewRect = get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
	
func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
		
	shieldSprite.visible = true	
	invincibilityTimer.start(damageInvincibilityTime)
	lives -= amount
	damageTakenSFX.play()
	Signals.emit_signal("on_player_life_change", lives)
	
	var cam := get_tree().current_scene.find_node("Cam", true, false)
	cam.shake(10)
	
	if lives <= 0:
		queue_free()


func _on_InvincibiltyTimer_timeout():
	shieldSprite.visible = false
