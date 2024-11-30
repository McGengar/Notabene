extends RigidBody2D

@export var movement_speed = 25
@export var hp = 100
var direction : Vector2

@onready var player = get_node("../Player")

func dealt_dmg(amount):
	$AnimatedSprite2D.animation = "dmg"
	hp-=amount
	if hp<=0:
		$CPUParticles2D.emitting= true
		$AnimatedSprite2D.visible=false
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
	else:
		$CPUParticles2D.emitting= true
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
		apply_central_force(direction*movement_speed*1000*delta)
