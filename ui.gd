extends Control
@onready var label_coins: Label = $labelCoins
@onready var label_life: Label = $labelLife

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_coins.text = str(Game.get_coins())
	label_life.text = str(Game.get_life())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_coins.text = str(Game.get_coins())
	label_life.text = str(Game.get_life())
