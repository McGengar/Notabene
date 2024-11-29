extends RigidBody2D

@export var movement_speed = 50
@export var hp = 60
var can_dash = true
var direction : Vector2

@onready var player = get_node("../../Player")


func _ready():
	$Timer.start()

func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		apply_central_force(direction*movement_speed*1000*delta)
	
	$HpBarFilling.scale.x = hp/60.0
	
	if hp<60:
		$HpBar.visible = true
		$HpBarFilling.visible = true
		hp+=1*delta
	
	if hp<=0 or hp>=60:
		$HpBar.visible = false
		$HpBarFilling.visible = false
		
	if can_dash and movement_speed<150:
		movement_speed+=10*delta
	if global_position.distance_to(player.global_position)<(movement_speed/2) and can_dash:	
		apply_central_force(direction*movement_speed*50000* delta)
		can_dash = false
		$ThunderSound.play()
		$Timer.start()
		movement_speed = 50
		

func _on_timer_timeout():
	can_dash = true
	


	


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "dmg":
		await get_tree().create_timer(0.2).timeout
		if $AnimatedSprite2D: $AnimatedSprite2D.animation = "default"
