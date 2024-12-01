extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(10).timeout
	$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
	await get_tree().create_timer(1.5).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogue/enddialogue.dialogue"), "start")
func exit():
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
