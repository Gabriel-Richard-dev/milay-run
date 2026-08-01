extends Camera2D

var target: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
	
	target = nodes[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = target.position
