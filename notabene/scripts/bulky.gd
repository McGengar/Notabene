extends RigidBody2D

@export var movement_speed = 15
@export var hp = 100
var direction : Vector2
var is_attacking = false

@onready var player = get_node("../Player")

func dealt_dmg(amount):
	hp-=amount
	$CPUParticles2D.emitting= true
	if hp<=0:
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		if is_attacking == false:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
			apply_central_force(direction*movement_speed*1000*delta)
func attack():
	is_attacking = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation="attack"
	$AnimatedSprite2D.play()
	await get_tree().create_timer(1).timeout
	$shockwave.monitoring = true
	$shockwave/CPUParticles2D.emitting =true
	$shockwave/CPUParticles2D2.emitting =true
	await get_tree().create_timer(0.1).timeout
	$shockwave.monitoring = false
	is_attacking = false
func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		attack()


func _on_shockwave_body_entered(body):
	if body.is_in_group("player"):
		body.take_dmg(50)
