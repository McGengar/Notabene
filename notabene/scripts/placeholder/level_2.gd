extends Node2D


var fading_in = false
var alpha = 0
var finished = 0
var disturbance = 0
var time = Globals.level_2_time
var boss_spawned = 0

var text = [
	"[center]Defeat all enemies[/center]",
	"[center]Strong enemy appeard[/center]",
	"[center]Defeat strong enemy using skills[/center]"
	#,"[center]Press Q to open Alchemist's Cookbook[/center]"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	disturbance= 0.7
	if Globals.level_2_time==0:
		await get_tree().create_timer(2).timeout
		fading_in = true
		$CanvasLayer/RichTextLabel.text = text[0]
		await get_tree().create_timer(3).timeout
		fading_in = false
		await get_tree().create_timer(2).timeout
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
		Globals.level_2_time=0
		finished = 0
		disturbance= 0
		$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0)
		get_tree().change_scene_to_packed(load("res://scenes/level_3.tscn"))
	$Player/CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", disturbance)

	if boss_spawned==1 and $Enemies.get_node("BigFireEnemy") == null:
		$AudioStreamPlayer2D3.stop()
		$Enemies/Spawner9.free()
		$Enemies/Spawner10.free()
		$Enemies/Spawner11.free()
		$Enemies/Spawner12.free()
		$Enemies/Spawner13.free()
		$Enemies/Spawner14.free()
		boss_spawned=2
	if boss_spawned==2:
		boss_spawned=3
		await get_tree().create_timer(2).timeout
		for body in $Enemies.get_children():
			$Player.destroy_enemy(body)
		await get_tree().create_timer(3).timeout
		finished = 2
		$Player/Sounds/LeveLTransition.play()


func _on_level_timer_timeout():
	time+=1
	match time:
		10:
			Globals.level_2_time=9
			$Enemies/Spawner.enabled= true
			$Enemies/Spawner2.enabled= true
			$Enemies/Spawner3.enabled= true
		11:
			$Enemies/Spawner.free()
			$Enemies/Spawner2.free()
			$Enemies/Spawner3.free()
		16:
			Globals.level_2_time=15
			$Enemies/Spawner4.enabled= true
			
		17:
			$Enemies/Spawner4.free()
			$Enemies/Spawner5.enabled= true
			$Enemies/Spawner6.enabled= true
			$Enemies/Spawner7.enabled= true
		18:
			$Enemies/Spawner5.free()
			$Enemies/Spawner6.free()
			$Enemies/Spawner7.free()
			
		25:
			$AudioStreamPlayer2D.stop()
			$AudioStreamPlayer2D3.play()
			Globals.level_2_time=24
			$Enemies/Spawner8.enabled = true
			$AudioStreamPlayer2D2.play()
			fading_in = true
			$CanvasLayer/RichTextLabel.text = text[1]
			await get_tree().create_timer(3).timeout
			fading_in = false
			await get_tree().create_timer(2).timeout
		26: 
			$Enemies/Spawner8.free()
		27:
			$Enemies/Spawner9.enabled=true
			$Enemies/Spawner10.enabled=true
			$Enemies/Spawner11.enabled=true
			$Enemies/Spawner12.enabled=true
			$Enemies/Spawner13.enabled=true
			$Enemies/Spawner14.enabled=true
			await get_tree().create_timer(1).timeout
			boss_spawned=1
		
		30:
			fading_in = true
			$CanvasLayer/RichTextLabel.text = text[2]
			await get_tree().create_timer(3).timeout
			fading_in = false
			await get_tree().create_timer(2).timeout
