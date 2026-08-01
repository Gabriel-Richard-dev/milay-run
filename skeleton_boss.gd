extends CharacterBody2D

enum SkeletonState {
	walk,
	attack,
	hurt,
	dead
}
@export var timer: Timer

const SPINNING_BONE = preload("res://spinning_bone.tscn")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

const SPEED = 200
const JUMP_VELOCITY = -400.0

var status: SkeletonState

var direction = 1
var can_throw = true

@export var throw_cooldown: float = 2.0  # segundos entre arremessos
var next_throw_msec = 0.0

func _ready() -> void:
	add_to_group("enemie")
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	
	if(Game.bossLife <= 0):
		status = SkeletonState.dead
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.attack:
			attack_state(delta)
		SkeletonState.hurt:
			hurt_state(delta)
		SkeletonState.dead:
			dead_state()

	move_and_slide()

func dead_state():
	return

func go_to_walk_state():
	status = SkeletonState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = SkeletonState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	
func go_to_hurt_state():
	Game.damageBoss()

	if Game.bossLife <= 0:
		status = SkeletonState.dead
		anim.play("hurt")
		velocity = Vector2.ZERO
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		timer.start()
		return

	status = SkeletonState.hurt
	anim.play("hurt")
	
func walk_state(_delta):
	if anim.frame == 3 or anim.frame == 4:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding() and Time.get_ticks_msec() >= next_throw_msec:
		go_to_attack_state()
		return

func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bone()
		can_throw = false

func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state()
	
func throw_bone():
	next_throw_msec = Time.get_ticks_msec() + throw_cooldown * 1000
	var new_bone = SPINNING_BONE.instantiate()
	add_sibling(new_bone)
	new_bone.global_position = bone_start_position.global_position
	var player = get_tree().get_first_node_in_group("player")
	if player:
		new_bone.launch_at(player.global_position)
	else:
		new_bone.set_direction(self.direction)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return

	if anim.animation == "hurt":
		if Game.bossLife <= 0:
			timer.start()
			return

		go_to_walk_state()

func _on_timer_timeout() -> void:
	call_deferred("load_next_scene")

func load_next_scene():
	get_tree().change_scene_to_file("res://final_dialog.tscn")
