extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var walldetector: RayCast2D = $walldetector
@onready var grounddetector: RayCast2D = $grounddetector


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

var direction = 1

enum SkeletonState {
	walk,
	jump
}
var g_delta = 0
var status: SkeletonState = SkeletonState.walk

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:

	# Add the gravity.
	g_delta = delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		SkeletonState.walk:
			walk_state()
		SkeletonState.jump:
			animation.play("jump")
			velocity.x = 0
			animation.flip_h = false
			
	
	
	move_and_slide()
	
func go_to_walk_state():
	status = SkeletonState.walk
	animation.play("walk")
	animation.flip_h = true
	

func walk_state():
	velocity.x = SPEED * direction
	
	if walldetector.is_colliding():
		direction *= -1
		scale.x *= -1
	
	if not grounddetector.is_colliding():
		direction *= -1
		scale.x *= -1
		
func start_jump():
	status = SkeletonState.jump
	direction = 1

func dead_state():
	velocity.x = 0

func go_to_end():
		call_deferred("load_next_scene")

func load_next_scene():
	get_tree().change_scene_to_file("res://the_end.tscn")
