extends Node2D

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dziecko_die():
	counter+=1
	if counter ==3:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(load("res://scenes/metronightafter.tscn"))

func _on_tentacle_monster_die():
	counter+=1
	if counter ==3:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(load("res://scenes/metronightafter.tscn"))

func _on_bulky_die():
	counter+=1
	if counter ==3:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(load("res://scenes/metronightafter.tscn"))
