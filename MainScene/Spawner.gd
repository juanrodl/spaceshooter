extends Node2D

const MIN_SPAWN_TIME = 1.5

var preloadedEnemies := [
	preload("res://MainScene/enemy/FastEnemy.tscn"),
	preload("res://MainScene/enemy/BouncerEnemy.tscn"),
	preload("res://MainScene/enemy/ShooterEnemy.tscn")
]

var plMeteor := preload("res://MainScene/Meteor.tscn")

onready var spawnTimer = $SpawnTimer
 
var nextSpawnTime := 5.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_SpawnTimer_timeout():
	# Spawn an enemy
	var viewRect := get_viewport_rect()
	var xPos := rand_range(viewRect.position.x, viewRect.end.x)
	
	if randf() < 0.1:
		var meteor: Meteor = plMeteor.instance()
		meteor.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(meteor)
	else:
		var enemyPreload = preloadedEnemies[randi() % preloadedEnemies.size()]
		var enemy = enemyPreload.instance()
		enemy.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(enemy)
		
	# Restart the timer
	nextSpawnTime -= 0.2
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
		
	spawnTimer.start(nextSpawnTime)
