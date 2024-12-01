extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_wyfe_die():
	$Sword.free()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(load("res://scenes/homeafter.tscn"))
