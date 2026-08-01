extends CharacterBody2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var coin_counter: Control = $CoinCounter

enum PlayerState {
	idle,
	walk,
	jump,
	dead
}

var status: PlayerState = PlayerState.idle
const JUMP_VELOCITY = -300.0
var g_delta = 0

@export var invuln_time: float = 1.5  # segundos de invencibilidade apos pisar num inimigo
var invuln_until_msec = 0.0

@export var SPEED = 150
@export var acceleration = 600
@export var deceleration = 600

func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, acceleration * g_delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * g_delta)
		
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false

func _ready() -> void:
	add_to_group("player")
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	g_delta = delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.dead:
			dead_state()
			
	move_and_slide()

func dead_state():
	velocity.x = 0
	pass

func go_to_dead_state():
	if status == PlayerState.dead or Time.get_ticks_msec() < invuln_until_msec:
		return
	status = PlayerState.dead
	animation.play("die")
	velocity = Vector2.ZERO
	reload_timer.start()
	Game.died()

func go_to_idle_state():
	status = PlayerState.idle
	animation.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	animation.play("walk")

func go_to_jump_state(force := false):
	if not force and not is_on_floor():
		return
	status = PlayerState.jump
	animation.play("jump")
	velocity.y = JUMP_VELOCITY
func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
		
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
func jump_state():
	move()
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return


func _on_hitbox_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent()
	if enemy.is_in_group("enemie"):
		if velocity.y > 0:
			enemy.take_damage()
			go_to_jump_state(true)
			invuln_until_msec = Time.get_ticks_msec() + invuln_time * 1000
		elif status != PlayerState.dead:
			go_to_dead_state()


func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
