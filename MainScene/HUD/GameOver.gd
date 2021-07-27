extends Label

onready var gameOverLabel := $

func _ready():
	printGameOver()
	
func printGameOver():
	var gameOver = gameOverLabel.instance()
	!gameOver.visible
		
	 


