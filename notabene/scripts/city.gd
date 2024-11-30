extends Node2D


var time = 0
var flag = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if flag and $Dogs/Dog.position.x>980:
		$Dogs/Dog.position.x-=1
		$Dogs/Dog2.position.x-=1
	
	if time > 6:
		if 	$Node2D/Player/Camera2D.zoom.x<16:
			$Node2D/Player/Camera2D.zoom.x*=1.003
			$Node2D/Player/Camera2D.zoom.y*=1.003
			$Node2D/Player.camera_shake(0.5)
		else:
			$Node2D/Player/Camera2D/Sprite2D2.visible=true
			$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/dog_fight.tscn"))
		
		

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Node2D/Player.can_move=false
		$Node2D/Player/AnimatedSprite2D.animation = "stand"
		flag = true


func _on_timer_timeout():
	if flag:
		time+=1
