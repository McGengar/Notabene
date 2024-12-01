extends Node2D
@onready var woman: AudioStreamPlayer = $woman

var zoomin = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if zoomin == true:
		$Node2D/Player.camera_shake(0.5)
		if $Node2D/Player/Camera2D.zoom.x<16:
			$Node2D/Player/Camera2D.zoom.x*=1.003
			$Node2D/Player/Camera2D.zoom.y*=1.003
		if $Node2D/Player/Camera2D.zoom.x>=16:
			woman.stop()
			$Earring.stop()
			$Node2D/Player/Camera2D/Sprite2D2.visible = true
			$Node2D/Player/Camera2D/Sprite2D2.modulate = Color(0,0,0,255)
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(load("res://scenes/wyfe_fight.tscn"))
func wife_zoom():
	zoomin = true
	$Earring.play()

func scream():
	woman.play()
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Node2D/Player.can_move =false
		$Node2D/Player/AnimatedSprite2D.animation = "stand"
		DialogueManager.show_dialogue_balloon(load("res://dialogue/wifedialogue.dialogue"), "start")
