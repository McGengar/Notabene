extends Area2D

var rising = true
func _ready():
	scale = Vector2(0.1,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale.x >2.4:
		rising = false
	if rising:
		scale = lerp(scale, Vector2(2.5,2.5), 0.008)
	else:
		scale = lerp(scale, Vector2(0,0), 0.05)
	if scale.x<0.1:
		queue_free()
		
		




	


func _on_body_entered(body):
	if body.is_in_group("enemy") and !body.is_in_group("fire_enemy"):
		body.get_node("AnimatedSprite2D").free()
		body.get_node("CollisionShape2D").free()
		body.get_node("CPUParticles2D").emitting = true
		body.get_node("CPUParticles2D2").emitting = false
		await get_tree().create_timer(0.5).timeout
		body.free()
	elif body.is_in_group("big_enemy") and !body.is_in_group("fire_enemy"):
		body.hp-=5
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
