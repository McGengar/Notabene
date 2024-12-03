extends RigidBody2D

@export var movement_speed = 20
@export var hp = 100
var direction : Vector2
@export var time = 0
@export var bullet: PackedScene
var has_left = false
@onready var player = get_node("../Player")

signal die

func dealt_dmg(amount):
	hp-=amount
	if hp<=0:
		emit_signal("die")
		$CPUParticles2D.emitting= true
		$AnimatedSprite2D.visible=false
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
	else:
		$CPUParticles2D.emitting= true
		await get_tree().create_timer(0.2).timeout
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		if direction.x <0:
			$AnimatedSprite2D.scale.x=1
		else:
			$AnimatedSprite2D.scale.x=-1
		apply_central_force(direction*movement_speed*1000*delta)


func _on_timer_timeout():
	time+=1
	if time==5:
		time=0;
		direction= Vector2.ZERO
		if player != null:
			$AudioStreamPlayer2D.play()
			direction.x = player.global_position.x -global_position.x 
			direction.y = player.global_position.y - global_position.y
			direction = direction.normalized()
			apply_central_force(direction*movement_speed*2000)
			await get_tree().create_timer(0.3).timeout
			if hp>0:
				if global_position.distance_to(player.global_position)<210:
						var cry = bullet.instantiate()
						get_parent().add_child(cry)
						cry.position = global_position
						cry.player_direction = direction
	



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		has_left = false
		body.take_dmg(25)
		while has_left == false:
			await get_tree().create_timer(1).timeout
			if has_left == true:
				break
			else:
				body.take_dmg(25)


func _on_area_2d_body_exited(body: Node2D) -> void:
	has_left = true
