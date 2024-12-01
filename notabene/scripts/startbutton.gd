extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/metro.tscn"))


func _on_texture_button_2_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
