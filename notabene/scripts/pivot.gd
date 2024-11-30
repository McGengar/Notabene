extends Node2D

@onready var player = get_node("../../Player")

func _physics_process(delta: float) -> void:
	if player: look_at(player.global_position)

func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		player.camera_shake(9)
