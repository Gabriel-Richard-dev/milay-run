extends Node2D
@onready var anim: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("cutscene")
	pass # Replace with function body.

func play_anim(s:String):
	anim.play(s)


func stop_anim():
	anim.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
