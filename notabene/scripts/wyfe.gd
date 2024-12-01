extends RigidBody2D
var time = 0
@export var movement_speed = 10
@export var hp = 150
var is_attacking = false
var direction : Vector2
@export var wyfebullet: PackedScene
@onready var player = get_node("../Player")

signal die

func dealt_dmg(amount):
	hp-=amount
	$CPUParticles2D.emitting= true
	if hp<=0:
		emit_signal("die")
		$AnimatedSprite2D.visible=false
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
	else:
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.animation = "walk"
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
	if is_attacking == false:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
		apply_central_force(direction*movement_speed*1000*delta)


func _on_timer_timeout() -> void:
	is_attacking = true
	$AnimatedSprite2D.animation = "spell"
	await get_tree().create_timer(1.0).timeout
	if hp>0:
		var bullet_dir : PackedVector2Array = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0), Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]
		if global_position.distance_to(player.global_position)<210:
			for x in range(3):
				for n in range(8):
						var cry = wyfebullet.instantiate()
						get_parent().add_child(cry)
						cry.position = global_position
						#bullet.rotation = deg_to_rad(45)*n
						cry.player_direction = bullet_dir[n]
				await get_tree().create_timer(0.3).timeout
	
	is_attacking = false
