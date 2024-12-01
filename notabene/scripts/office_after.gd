extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4).timeout
	$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(load("res://scenes/metronight.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
