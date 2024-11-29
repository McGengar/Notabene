extends RigidBody2D

@export var movement_speed = 1
var direction : Vector2

@onready var player = get_node("../../Player")

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		apply_central_force(direction*movement_speed*1000*delta)
		if $Timer.time_left==0 and global_position.distance_to(player.global_position)<85:
				apply_central_force(direction*movement_speed*10000)
				$Timer.start(-2.5)


