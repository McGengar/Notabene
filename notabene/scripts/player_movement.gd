extends RigidBody2D

var character_direction : Vector2
@export var movement_speed = 10.0
@export var dash_strength = 3000.0
@export var player_pos : Vector2
var is_attacking = false
var can_attack = true
var can_dash = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$pivot/AnimatedSprite2D2.visible = false
	$AnimatedSprite2D.animation = "stand"
	$pivot/AnimatedSprite2D2.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	player_pos = global_position
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	character_direction = character_direction.normalized()
	
	if character_direction.x<0:
		$pivot.scale.x=-1
	else:
		$pivot.scale.x=1
	if Input.is_action_just_pressed("attack") and can_attack:
		if character_direction.x<0:
			$AnimatedSprite2D.flip_h = true
		is_attacking = true
		can_attack = false
		$pivot/AnimatedSprite2D2.visible= true
		$AnimatedSprite2D.animation = "attack"
		$pivot/AnimatedSprite2D2.play()
		await get_tree().create_timer(0.25).timeout
		$AnimatedSprite2D.flip_h = false
		is_attacking = false
		await get_tree().create_timer(0.25).timeout
		can_attack = true
		
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		$AnimatedSprite2D/CPUParticles2D.emitting = true
		apply_central_force(character_direction*dash_strength*1000*delta)
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D/CPUParticles2D.emitting = false
		await get_tree().create_timer(0.4).timeout
		can_dash = true
		
		
	if is_attacking ==false:
		if character_direction.x!=0 or character_direction.y!=0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.animation = "stand"
		apply_central_force(character_direction*movement_speed*1000*delta)
		
		
	
