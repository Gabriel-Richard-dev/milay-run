extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60
var direction = 1
var velocity = Vector2.ZERO
var fall_accel = 0.0

func _physics_process(delta: float) -> void:
	if fall_accel == 0.0:
		position.x += speed * delta * direction
		return
	velocity.y += fall_accel * delta
	position += velocity * delta

func set_direction(skeleton_direction):
	direction = skeleton_direction
	anim.flip_h = direction < 0

# Arremesso em arco: sai pra cima e cai na altura do alvo.
func launch_at(target_position: Vector2, arc_gravity := 600.0):
	fall_accel = arc_gravity
	var to_target = target_position - global_position
	var time = max(abs(to_target.x) / speed, 0.2)
	velocity = Vector2(to_target.x / time, to_target.y / time - 0.5 * fall_accel * time)
	set_direction(1 if to_target.x >= 0 else -1)

func _on_self_destruct_timer_timeout() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.status != body.PlayerState.dead:
		body.go_to_dead_state()
	queue_free()
