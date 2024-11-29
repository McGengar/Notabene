extends Node2D


var fading_in = false
var alpha = 0
var finished = 0
var disturbance = 0
var text = [
	"[center]Thanks for playing! Now you can test all enemies and combinations in this debug level[/center]"
	#,"[center]Press Q to open Alchemist's Cookbook[/center]"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	disturbance= 0.7
	if Globals.level_test_time==0:
		await get_tree().create_timer(2).timeout
		fading_in = true
		$CanvasLayer/RichTextLabel.text = text[0]
		await get_tree().create_timer(3).timeout
		fading_in = false
		await get_tree().create_timer(2).timeout
		Globals.level_test_time=1
	#fading_in = true
	#$CanvasLayer/RichTextLabel.text = text[1]
	#await get_tree().create_timer(5).timeout
	#fading_in = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading_in and alpha<1:
		alpha += 0.5*delta
	elif fading_in==false and alpha > 0:
		alpha -= 0.5*delta
	$CanvasLayer/RichTextLabel.modulate = Color(1,1,1,alpha)
	if finished == 2 and disturbance<1:
		disturbance +=0.4*delta
	elif finished==0 and disturbance>0:
		disturbance -=0.4*delta
	if disturbance>0.8:
		await get_tree().create_timer(0.5).timeout
		Globals.level_test_time=0
		finished = 0
		disturbance= 0
		$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0)
		get_tree().change_scene_to_packed(load("res://scenes/test_level.tscn"))
	$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", disturbance)
