extends RigidBody2D

@export var movement_speed = 20
@export var player_direction : Vector2 = Vector2(1,0)
var direction : Vector2
@onready var player: RigidBody2D = $Player


func _physics_process(delta):
	player_direction = player_direction.normalized()
	
	apply_central_force(player_direction*movement_speed*1000*delta)





func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.take_dmg(20)
