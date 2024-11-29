extends RigidBody2D

@export var movement_speed = 10
@export var magma : PackedScene
@export var hp = 100

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
	
	$HpBarFilling.scale.x = hp/100.0
	
	if hp<100:
		$HpBar.visible = true
		$HpBarFilling.visible = true
		#hp+=1*delta
	
	if hp<=0 or hp>=100:
		$HpBar.visible = false
		$HpBarFilling.visible = false


func _on_timer_timeout():
	var puddle = magma.instantiate()	
	puddle.position = global_position - Vector2(0,-25)
	get_parent().add_child(puddle)


	


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "dmg":
		await get_tree().create_timer(0.2).timeout
		if $AnimatedSprite2D: $AnimatedSprite2D.animation = "default"
		
	


func _on_tree_exiting():
	if is_queued_for_deletion():
		$Sounds.stop()
