extends Node2D

var disturbance = 0
var noise_up = false
# Called when the node enters the scene tree for the first time.
func _ready():
	disturbance= 0.7


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", disturbance)
	if noise_up and disturbance<1:
		disturbance+=1*delta
	if noise_up==false and disturbance>0:
		disturbance-=1*delta
func _on_start_pressed():
	$CanvasLayer/Start/StartButton.modulate = Color(0.3,0.3,0.3,1)
	noise_up = true
	$LeveLTransition.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(load("res://scenes/level_1.tscn"))



func _on_exit_pressed():
	noise_up = true
	$LeveLTransition.play()
	$CanvasLayer/Exit/ExitButton.modulate = Color(0.3,0.3,0.3,1)
	await get_tree().create_timer(1).timeout
	get_tree().quit()
