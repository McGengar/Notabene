extends Node2D

var zoomin = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoomin ==true:
		$Node2D/Player.camera_shake(0.5)
		if $Node2D/Player/Camera2D.zoom.x<16:
			$Node2D/Player/Camera2D.zoom.x*=1.003
			$Node2D/Player/Camera2D.zoom.y*=1.003
		if $Node2D/Player/Camera2D.zoom.x>=16:
			$Earring.stop()
			$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/finale.tscn"))


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Node2D/Player.can_move=false
		$Node2D/Player/AnimatedSprite2D.animation="stand"
		await get_tree().create_timer(2).timeout
		$Earring.play()
		zoomin = true
