extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.01).timeout
	$CPUParticles2D.emitting = true
	$CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(0.2).timeout
	$CPUParticles2D.emitting = false
	$CollisionShape2D.set_deferred("disabled", true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body.is_in_group("player"):
		body.die()
	if body.is_in_group("enemy") and !body.is_in_group("earth_enemy"):
		body.get_node("AnimatedSprite2D").free()
		body.get_node("CollisionShape2D").free()
		body.get_node("CPUParticles2D").emitting = true
		body.get_node("CPUParticles2D2").emitting = false
		await get_tree().create_timer(0.5).timeout
		body.free()
