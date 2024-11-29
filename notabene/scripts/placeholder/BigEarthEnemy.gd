extends RigidBody2D

@export var movement_speed = 10
@export var hp = 200
var can_dash = false
var direction : Vector2
@export var shockwave : PackedScene

@onready var player = get_node("../../Player")


func _ready():
	$Timer.start()

func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		apply_central_force(direction*movement_speed*10000*delta)
	
	$HpBarFilling.scale.x = hp/200.0
	
	if hp<200:
		$HpBar.visible = true
		$HpBarFilling.visible = true
		hp+=1*delta
	
	if hp<=0 or hp>=200:
		$HpBar.visible = false
		$HpBarFilling.visible = false
	
	if $AnimatedSprite2D==null:
		can_dash=false
	
	if global_position.distance_to(player.global_position)<170 and can_dash:	
		$AudioStreamPlayer2D2.play()
		apply_central_force(direction*movement_speed*3000000* delta)
		can_dash = false
		$Timer.start()
		player.camera_shake(30)
		await get_tree().create_timer(1).timeout
		player.camera_shake(20)
		if $AnimatedSprite2D!=null:
			var bullet = shockwave.instantiate()
			$AudioStreamPlayer2D.play()
			get_parent().add_child(bullet)
			bullet.position = global_position
		
		

func _on_timer_timeout():
	can_dash = true
	


	


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "dmg":
		await get_tree().create_timer(0.2).timeout
		if $AnimatedSprite2D: $AnimatedSprite2D.animation = "default"
