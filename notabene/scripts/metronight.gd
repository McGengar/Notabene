extends Node2D

var r_str = 5.0
var shake_fade = 5.0
var rng = RandomNumberGenerator.new()
var shake_str = 0
@onready var baby: AudioStreamPlayer = $baby
@onready var metro: AudioStreamPlayer = $metro

var time=0

func camera_shake(str = r_str):
	shake_str=str
func random_offset():
		return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	baby.play()

func _physics_process(delta: float) -> void:
	camera_shake(0.5)
	$Camera2D.offset=random_offset()
	if shake_str>0:
		shake_str = lerpf(shake_str,0,shake_fade*delta)
		$Camera2D.offset=random_offset()
	if time>7:
		if 	$Camera2D.zoom.x<8:
			
			$Camera2D.zoom.x*=1.001
			$Camera2D.zoom.y*=1.001
		else:
			metro.stop()
			baby.stop()
			$Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			$Camera2D/Sprite2D2.visible = true
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/marriagefight.tscn"))
	

func _on_timer_timeout():
	time+=1
