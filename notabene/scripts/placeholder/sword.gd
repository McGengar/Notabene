extends RigidBody2D

@onready var player = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if player != null:
		position.x =lerp(position.x,player.position.x, 0.05)
		position.y =lerp(position.y,player.position.y, 0.05)
	
