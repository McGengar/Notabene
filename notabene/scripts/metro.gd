extends Node2D

var r_str = 10.0
var shake_fade = 5.0
var rng = RandomNumberGenerator.new()
var shake_str = 0

var time=0

var alpha=1

func camera_shake(str = r_str):
	shake_str=str
func random_offset():
		return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$Camera2D.offset=random_offset()
	if shake_str>0:
		shake_str = lerpf(shake_str,0,shake_fade*delta)
		$Camera2D.offset=random_offset()
	
	if time<3:
		if alpha>0:
			alpha-=0.01                 
	$Camera2D/Sprite2D2.modulate = Color(255,255,255,alpha)
	
	if time>8:
		if 	$Camera2D.zoom.x<7:
			camera_shake(0.5)
			$Camera2D.zoom.x*=1.0007
			$Camera2D.zoom.y*=1.0007
		else:
			$Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/office.tscn"))
	

func _on_timer_timeout():
	time+=1
