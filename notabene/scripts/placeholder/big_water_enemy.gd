extends RigidBody2D

@export var movement_speed = 5
@export var bubble : PackedScene
@export var hp = 150

var direction : Vector2
@onready var player = get_node("../../Player")

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		apply_central_force(direction*movement_speed*1000*delta)
	
	$HpBarFilling.scale.x = hp/150.0
	
	if hp<150:
		$HpBar.visible = true
		$HpBarFilling.visible = true
		hp+=2.5*delta
	
	if hp<=0 or hp>=150:
		$HpBar.visible = false
		$HpBarFilling.visible = false
		
	

	

func _on_timer_timeout():
	if hp>0:
		var bubble_dir : PackedVector2Array = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0), Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]
		if global_position.distance_to(player.global_position)<210:
			$AudioStreamPlayer2D.play()
			for n in range(8):
						var bullet = bubble.instantiate()
						get_parent().add_child(bullet)
						bullet.position = global_position - Vector2(5,0)
						#bullet.rotation = deg_to_rad(45)*n
						bullet.player_direction = bubble_dir[n]
	


	


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "dmg":
		await get_tree().create_timer(0.2).timeout
		if $AnimatedSprite2D: $AnimatedSprite2D.animation = "default"
