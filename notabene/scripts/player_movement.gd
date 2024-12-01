extends RigidBody2D

var character_direction : Vector2
@export var movement_speed = 10.0
@export var dash_strength = 3000.0
@export var player_pos : Vector2
var is_attacking = false
@export var can_attack = true
@export var can_dash = true
@export var can_move = true
@export var hp = 100.0

var r_str = 10.0
var shake_fade = 5.0
var rng = RandomNumberGenerator.new()
var shake_str = 0

var last_dir= 1

func camera_shake(str = r_str):
	shake_str=str
func random_offset():
		return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))


func take_dmg(amount):
	camera_shake(10)
	
	if hp-amount<=0:
		hp=0
		$AnimatedSprite2D.visible=false
		can_move = false
		can_dash = false
		can_attack = false
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(2).timeout
		get_tree().reload_current_scene()
	else:
		hp-=amount
		$damaged.pitch_scale = randf_range(0.9,1.1)
		$damaged.play()
	


# Called when the node enters the scene tree for the first time.
func _ready():
	$pivot/AnimatedSprite2D2.visible = false
	$AnimatedSprite2D.animation = "stand"
	$pivot/AnimatedSprite2D2.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Camera2D/Sprite2D.material.set("shader_parameter/vignette_amount", 10-9*(hp/100))
	if hp>0 and hp<100:
		hp+=7.5*delta
	$Camera2D.offset=random_offset()
	if shake_str>0:
		shake_str = lerpf(shake_str,0,shake_fade*delta)
		$Camera2D.offset=random_offset()
	player_pos = global_position
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	character_direction = character_direction.normalized()
	
	if character_direction.x>0:
		last_dir=1
	if character_direction.x<0:
		last_dir=-1
	
	if Input.is_action_just_pressed("attack") and can_attack:
		if last_dir==-1:
			$pivot.scale.x=-1
			$AnimatedSprite2D.flip_h = true
		is_attacking = true
		can_attack = false
		$pivot/AnimatedSprite2D2/Area2D.monitoring = true
		camera_shake(5)
		$pivot/AnimatedSprite2D2.visible= true
		$AnimatedSprite2D.animation = "attack"
		$pivot/AnimatedSprite2D2.play()
		$Slash.pitch_scale = randf_range(0.9,1.1)
		$Slash.play()
		await get_tree().create_timer(0.25).timeout
		$AnimatedSprite2D.flip_h = false
		$pivot/AnimatedSprite2D2/Area2D.monitoring = false
		is_attacking = false
		await get_tree().create_timer(0.25).timeout
		$pivot.scale.x=1
		can_attack = true
		
	if Input.is_action_just_pressed("dash") and can_dash and character_direction!=Vector2(0,0):
		can_dash = false
		collision_mask = 0
		collision_layer = 0
		$AnimatedSprite2D/CPUParticles2D.emitting = true
		apply_central_force(character_direction*dash_strength*1000*delta)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D/CPUParticles2D.emitting = false
		await get_tree().create_timer(0.3).timeout
		collision_mask = 1
		collision_layer = 1
		await get_tree().create_timer(0.1).timeout
		can_dash = true
		
		
	if is_attacking ==false and can_move:
		if character_direction.x!=0 or character_direction.y!=0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.animation = "stand"
		apply_central_force(character_direction*movement_speed*1000*delta)
		
		
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.dealt_dmg(10)
