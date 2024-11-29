extends RigidBody2D

var character_direction : Vector2
@export var movement_speed = 10.0
@export var dash_strength = 3000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	character_direction = character_direction.normalized()
	if character_direction.x!=0 or character_direction.y!=0:
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "stand"
	apply_central_force(character_direction*movement_speed*1000*delta)

	#if Input.is_action_just_pressed("dash"):
	#	apply_central_force(character_direction*dash_strength*1000*delta)
