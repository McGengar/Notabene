extends RigidBody2D
var time = 0
@export var movement_speed = 10
@export var hp = 150
var is_attacking = false
var direction : Vector2
@export var wyfebullet: PackedScene
@onready var player = get_node("../Player")

func dealt_dmg(amount):
	hp-=amount
	if hp<=0:
		$AnimatedSprite2D.visible=false
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
	else:
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.animation = "default"
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
	$AnimatedSprite2D.animation = "attack"
	await get_tree().create_timer(1.4).timeout
	#tutaj
	is_attacking = false
