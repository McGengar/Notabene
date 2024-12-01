extends RigidBody2D

@export var movement_speed = 25
@export var hp = 100
var direction : Vector2
var is_dashing = false
@onready var stab: AudioStreamPlayer = $stab

@onready var player = get_node("../Player")

func _physics_process(delta):
	#player = $"../../Player"
	
	if player != null and is_dashing==false:
		look_at(player.global_position)
		direction= Vector2.ZERO
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		apply_central_force(direction*movement_speed*1000*delta)


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		stab.play()
		body.take_dmg(20)
		direction= Vector2.ZERO
		if player != null:
			is_dashing =true
			direction.x = player.global_position.x -global_position.x 
			direction.y = player.global_position.y - global_position.y
			direction = direction.normalized()
			#direction *= -1
			apply_central_force(direction*movement_speed*500)
			await get_tree().create_timer(0.25).timeout
			is_dashing=false
