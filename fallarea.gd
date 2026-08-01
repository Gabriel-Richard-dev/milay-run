extends Node2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var g_delta = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	g_delta = delta
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	Game.died()
	get_tree().reload_current_scene()
	
func take_damage():
	pass
