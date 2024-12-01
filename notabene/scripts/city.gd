extends Node2D

var rng = RandomNumberGenerator
var time = 0
var flag = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var dog_bark: AudioStreamPlayer = $"dog bark"
@onready var dogambient: AudioStreamPlayer = $dogambient
var has_barked = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pitch = randf_range(0.95,1.15)
	dog_bark.pitch_scale = pitch
	if flag and $Dogs/Dog.position.x>980:
		$Dogs/Dog.position.x-=1
		$Dogs/Dog2.position.x-=1
	if flag == true and has_barked == false:
		bark()
	if time ==6:
		$Earring.play()
	if time > 6:
		if 	$Node2D/Player/Camera2D.zoom.x<16:
			$Node2D/Player/Camera2D.zoom.x*=1.003
			$Node2D/Player/Camera2D.zoom.y*=1.003
			$Node2D/Player.camera_shake(0.5)
		else:
			$Earring.play()
			dog_bark.stop()
			$Node2D/Player/Camera2D/Sprite2D2.visible=true
			$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/dog_fight.tscn"))
		
		
func bark():
	dogambient.stop()
	dog_bark.play()
	has_barked = true
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Node2D/Player.can_move=false
		$Node2D/Player/AnimatedSprite2D.animation = "stand"
		flag = true


func _on_timer_timeout():
	if flag:
		time+=1
