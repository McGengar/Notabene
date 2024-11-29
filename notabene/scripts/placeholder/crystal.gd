extends RigidBody2D

@export var movement_speed = 50
@export var player_direction : Vector2 = Vector2(1,0)
var direction : Vector2

func _ready():
	await get_tree().create_timer(5).timeout
	#if $".":free()

func _physics_process(delta):
	player_direction = player_direction.normalized()
	apply_central_force(player_direction*movement_speed*1000*delta)
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.get_node("AnimatedSprite2D").free()
		body.get_node("CollisionShape2D").free()
		body.get_node("CPUParticles2D").emitting = true
		body.get_node("CPUParticles2D2").emitting = false
		await get_tree().create_timer(0.5).timeout
		body.free()
	elif body.is_in_group("big_enemy"):
		body.hp-=34
		if body.hp<=0:
			body.get_node("AnimatedSprite2D").free()
			body.get_node("CollisionShape2D").free()
			body.get_node("CPUParticles2D").emitting = true
			body.get_node("CPUParticles2D2").emitting = false
			body.get_node("CPUParticles2D3").emitting = false
			await get_tree().create_timer(0.5).timeout
			body.free()
		else:
			body.get_node("CPUParticles2D").emitting = true
			body.get_node("CPUParticles2D").emitting = false
			body.get_node("AnimatedSprite2D").animation = "dmg"

