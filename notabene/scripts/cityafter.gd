extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	sprite_2d.visible = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(load("res://scenes/home.tscn"))
