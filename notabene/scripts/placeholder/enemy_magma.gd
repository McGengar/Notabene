extends Area2D

var rising = true
func _ready():
	scale = Vector2(0.1,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale.x >2.8:
		await get_tree().create_timer(5).timeout
		rising = false
	if rising:
		scale = lerp(scale, Vector2(3,3), 0.05)
	else:
		scale = lerp(scale, Vector2(0,0), 0.01)
	if scale.x<0.1:
		queue_free()
		




	


