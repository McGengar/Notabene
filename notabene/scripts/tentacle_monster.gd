extends RigidBody2D

var time: float = 0.0
var rng = RandomNumberGenerator.new()
@export var movement_speed = 25
@export var hp = 100
var direction : Vector2
@onready var player = get_node("../Player")
var is_attacking = false
@onready var atak_area: Area2D = $pivot/AreaAtak
@onready var pivot: Node2D = $pivot
func _ready() -> void:
	atak_area.monitoring = false
	pivot.visible = false

func _process(delta: float) -> void:
	time+= delta
func dealt_dmg(amount):
	hp-=amount
	if hp<=0:
		$AnimatedSprite2D.visible=false
		collision_layer = 0
		collision_mask = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
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
	$AnimatedSprite2D.stop()
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.animation="attack"
	await get_tree().create_timer(0.5).timeout
	var rand_number = rng.randf_range(0,10)
	if rand_number < 11:
		
		atak_area.monitoring = true
		pivot.visible = true
		
		$pivot/AnimatedSprite2D.frame = 0
		$pivot/AnimatedSprite2D.play()
		await get_tree().create_timer(0.1).timeout
		atak_area.monitoring = false
		pivot.visible = false
		
		pass #stab
	else:
		pass #special
	is_attacking = false

func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		attack()
		
		


func _on_area_atak_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		body.hp -= 10
		player.camera_shake(9)
