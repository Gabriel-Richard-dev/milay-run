extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var walldetector: RayCast2D = $walldetector
@onready var grounddetector: RayCast2D = $grounddetector


const SPEED = 10.0
const JUMP_VELOCITY = -400.0

var direction = 1

enum SkeletonState {
	walk,
	dead
}
var g_delta = 0
var status: SkeletonState = SkeletonState.walk
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox

func _ready() -> void:
	add_to_group("enemie")
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	g_delta = delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		SkeletonState.walk:
			walk_state()
		SkeletonState.dead:
			dead_state()
	
	
	move_and_slide()
	
func go_to_walk_state():
	status = SkeletonState.walk
	animation.play("walk")
func go_to_dead_state():
	status = SkeletonState.dead
	animation.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	

func walk_state():
	velocity.x = SPEED * direction
	
	if walldetector.is_colliding():
		direction *= -1
		scale.x *= -1
	
	if not grounddetector.is_colliding():
		direction *= -1
		scale.x *= -1
		
func dead_state():
	velocity.x = 0

func take_damage():
	go_to_dead_state()
