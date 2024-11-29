extends Node2D


var fading_in = false
var alpha = 0
var spawner_alpha = 0
var finished = 0
var disturbance = 0
var time = 0

var text = [
	"[center]Use WASD to move around[/center]",
	"[center]Press Shift/LMB to dash[/center]",
	"[center]Dash through small enemies to defeat them[/center]",
	"[center]Dashing through small enemies lets you absorb their element[/center]",
	"[center]Absorb two different elements and press E/RMB to use skill[/center]"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	time=Globals.level_1_time
	disturbance= 0.7
	$Enemies/Spawner.enabled = false
	await get_tree().create_timer(2).timeout
	for t in range(len(text)):
		if time==2 and t<2:
			continue
		fading_in = true
		$CanvasLayer/RichTextLabel.text = text[t]
		if t==2:
			Globals.level_1_time=2
			$Enemies/Spawner.enabled = true
		if t==4:
			finished = 1
		await get_tree().create_timer(5).timeout
		fading_in = false
		await get_tree().create_timer(2).timeout
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if $Enemies/Spawner.enabled==true and spawner_alpha<1:
		spawner_alpha += 0.5*delta
	
	if fading_in and alpha<1:
		alpha += 0.5*delta
	elif fading_in==false and alpha > 0:
		alpha -= 0.5*delta
	$CanvasLayer/RichTextLabel.modulate = Color(1,1,1,alpha)
	$Enemies/Spawner.modulate = Color(1,1,1,spawner_alpha)
	
	if $Player/Explosion/CollisionShape2D.disabled==false and finished == 1:
		await get_tree().create_timer(1).timeout
		finished = 2
		$Player/Sounds/LeveLTransition.play()
		$Enemies/Spawner.enabled=false
	if finished == 2 and disturbance<1:
		disturbance +=0.4*delta
	elif finished==0 and disturbance>0:
		disturbance -=0.4*delta
	if disturbance>0.8:
		await get_tree().create_timer(0.5).timeout
		Globals.level_1_time=0
		finished = 0
		disturbance= 0
		$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0)
		get_tree().change_scene_to_packed(load("res://scenes/level_2.tscn"))
	$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", disturbance)

func _on_spawner_spawn():
	$Enemies/Spawner.rate = 6
	if $Enemies/Spawner.choice == 0:
		$Enemies/Spawner.choice = 2
	else: $Enemies/Spawner.choice = 0
