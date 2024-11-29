extends Node2D


var fading_in = false
var alpha = 0
var finished = 0
var disturbance = 0
var time = 0
var boss_spawned = 0

var text = [
	"[center]Try to find enemy's weakness[/center]",
	"[center]Strong enemies appeared[/center]"
	#,"[center]Press Q to open Alchemist's Cookbook[/center]"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	disturbance= 0.7
	if Globals.level_3_time==0:
		await get_tree().create_timer(2).timeout
		fading_in = true
		$CanvasLayer/RichTextLabel.text = text[0]
		await get_tree().create_timer(3).timeout
		fading_in = false
		await get_tree().create_timer(2).timeout
	elif Globals.level_3_time==1:
		time = 3
		$AudioStreamPlayer2D.stop()
		$Enemies/Spawner.free()
		boss_spawned=2
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
		Globals.level_3_time=0
		finished = 0
		disturbance= 0
		$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0)
		get_tree().change_scene_to_packed(load("res://scenes/level_4.tscn"))
	$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", disturbance)

	if boss_spawned==1 and $Enemies.get_node("BigWaterEnemy") == null:
		boss_spawned=2
		await get_tree().create_timer(5).timeout
		Globals.level_3_time=1
	
	if boss_spawned==3 and $Enemies.get_node("BigElectricEnemy") == null and $Enemies.get_node("BigElectricEnemy2") == null:
		$AudioStreamPlayer2D3.stop()
		$Enemies/Spawner2.free()
		$Enemies/Spawner3.free()
		$Enemies/Spawner4.free()
		boss_spawned=4
		
	if boss_spawned==4:
		boss_spawned=5
		await get_tree().create_timer(2).timeout
		for body in $Enemies.get_children():
			$Player.destroy_enemy(body)
		await get_tree().create_timer(3).timeout
		finished = 2
		$Player/Sounds/LeveLTransition.play()
	
func _on_level_timer_timeout():
	if boss_spawned<2 and time<3:
		time+=1
	elif boss_spawned>=2:
		time+=1
	match time:
		2:
			$Enemies/Spawner.free()
			boss_spawned=1
		6:
			$AudioStreamPlayer2D.stop()
			$AudioStreamPlayer2D2.play()
			$AudioStreamPlayer2D3.play()
			$Enemies/Spawner5.enabled=true
			$Enemies/Spawner6.enabled=true
		7:
			$Enemies/Spawner5.free()
			$Enemies/Spawner6.free()
			boss_spawned=3
			fading_in = true
			$CanvasLayer/RichTextLabel.text = text[1]
		10:
			fading_in = false
