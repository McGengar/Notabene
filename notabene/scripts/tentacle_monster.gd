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
var has_left = false
var invincible = false
signal die
@onready var klang: AudioStreamPlayer = $klang
@export var bullet: PackedScene
var damage = 30

func _ready() -> void:
	atak_area.monitoring = false
	pivot.visible = false

func _process(delta: float) -> void:
	time+= delta
func dealt_dmg(amount):
	if invincible == false:
		hp-=amount
	else:
		klang.play()
	$CPUParticles2D.emitting= true
	if hp<=0:
		emit_signal("die")
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
	invincible = true
	$AnimatedSprite2D.animation="attack"
	await get_tree().create_timer(0.4).timeout
	invincible = false
	$AudioStreamPlayer2D.play()
	atak_area.monitoring = true
	pivot.visible = true
	$pivot/AnimatedSprite2D.frame = 0
	$pivot/AnimatedSprite2D.play()
	await get_tree().create_timer(0.2).timeout
	atak_area.monitoring = false
	pivot.visible = false
	is_attacking = false

func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		has_left = false
		attack()
		while has_left == false:
			await get_tree().create_timer(0.4).timeout
			if has_left == true:
				break
			else:
				attack()
		


func _on_area_atak_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("player"):
		body.take_dmg(30)
		player.camera_shake(9)


func _on_area_2d_body_exited(body: Node2D) -> void:
	has_left = true


func _on_timer_2_timeout() -> void:
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		if hp>0:
			movement_speed = 10
			var cry = bullet.instantiate()
			get_parent().add_child(cry)
			cry.position = global_position
			cry.player_direction = direction
			await get_tree().create_timer(3).timeout
			movement_speed = 25
