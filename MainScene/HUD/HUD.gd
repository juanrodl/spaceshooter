extends Control

var pLifeIcon := preload("res://MainScene/HUD/LifeIcon.tscn")

onready var lifeContainer = $LifeContainer
onready var scoreLabel = $Score
onready var gameOverLabel = $GameOver
onready var enemyDestroyedSFX = $EnemyDestroyedSFX
onready var gameOverSFX = $GameOverSFX

var score: int = 0

func _ready():
	clearLives()
	Signals.connect("on_player_life_change", self, "_on_player_life_change")
	Signals.connect("on_score_increment", self, "_on_score_increment")
	gameOverLabel.visible = false
	
	
func clearLives():
	for child in lifeContainer.get_children():
		child.queue_free()
		
func setLives(lives: int):
	clearLives()
	if lives <= 0:
		printGameOver()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instance())
	
func printGameOver():
	gameOverLabel.visible = true
	gameOverSFX.play()
		
func _on_player_life_change(life: int):
	setLives(life)

func _on_score_increment(amount: int):
	score += amount
	scoreLabel.text = str(score)
	enemyDestroyedSFX.play()
