extends RigidBody2D

var time: float = 0.0
var rng = RandomNumberGenerator.new()
@export var movement_speed = 25
@export var hp = 100
var direction : Vector2
@onready var player = get_node("../Player")
var is_attacking = false
func _process(delta: float) -> void:
	time+= delta
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
func attack():
	is_attacking = true
	var rand_number = rng.randf_range(0,10)
	if rand_number < 7:
		
		
		
		pass #stab
	else:
		pass #special

func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		attack()
		is_attacking = false
		
