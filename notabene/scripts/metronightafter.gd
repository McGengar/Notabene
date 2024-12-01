extends Node2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var time = 0
# Called when the node enters the scene tree for the first time.


func _on_timer_timeout() -> void:
	sprite_2d_2.visible = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(load("res://scenes/city.tscn"))
