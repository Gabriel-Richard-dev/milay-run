extends Node

var coins := 0
var lifes := 3
var bossLife := 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reset():
	coins = 0
	lifes = 3
	bossLife = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_coin():
	coins += 1
	if coins >= 10:
		coins = 0
		lifes += 1

func add_life():
	lifes += 1

func died():
	lifes -= 1
	
	if(coins > 0):
		coins -= 1
	
	if lifes <= 0:
		call_deferred("load_next_scene")
		reset()

func load_next_scene():
	get_tree().change_scene_to_file("res://initial_page.tscn")
	
func get_life():
	return lifes

func damageBoss():
	bossLife -= 1

func get_coins():
	return coins
