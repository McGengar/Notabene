extends Node2D

var time =0
var zoomin = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/Player.can_move =false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if time>1 and zoomin==false:
		$Node2D/Player/Camera2D.zoom.x= lerpf($Node2D/Player/Camera2D.zoom.x, 4, 2*delta)
		$Node2D/Player/Camera2D.zoom.y= lerpf($Node2D/Player/Camera2D.zoom.y, 4, 2*delta)
	if time==4:
		$Node2D/Player.can_move =true	
	
	if time>5 and $Node2D/Player/Camera2D/AnimatedSprite2D.frame == 1:
		$Node2D/Player/Camera2D/AnimatedSprite2D.visible=false
	if zoomin == true:
		$Node2D/Player.camera_shake(0.5)
		if $Node2D/Player/Camera2D.zoom.x<16:
			$Node2D/Player/Camera2D.zoom.x*=1.003
			$Node2D/Player/Camera2D.zoom.y*=1.003
		if $Node2D/Player/Camera2D.zoom.x>=16:
			$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/boss_fight.tscn"))

func _on_timer_timeout():
	time+=1

func camera_zoom():
	zoomin = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Node2D/Player.can_move =false
		$Node2D/Player/AnimatedSprite2D.animation = "stand"
		DialogueManager.show_dialogue_balloon(load("res://dialogue/dialogue.dialogue"), "start")
		
