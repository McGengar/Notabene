extends RigidBody2D

@export var movement_speed = 30
@export var hp = 35
@export var shield = true
var direction : Vector2
@onready var player = get_node("../../Player")


func _ready():
	$Timer.start()
	shield = true

func _physics_process(delta):
	#player = $"../../Player"
	direction= Vector2.ZERO
	if player != null:
		direction.x = player.global_position.x -global_position.x 
		direction.y = player.global_position.y - global_position.y
		direction = direction.normalized()
		if shield:apply_central_force(direction*movement_speed*1000*delta)
		elif global_position.distance_to(player.global_position)<150:apply_central_force(direction*Vector2(-1,-1)*movement_speed*1500*delta)
	$HpBarFilling.scale.x = hp/35.0
	
	if hp<35:
		$HpBar.visible = true
		$HpBarFilling.visible = true
		if shield:hp+=5*delta
	
	if hp<=0 or hp>=35:
		$HpBar.visible = false
		$HpBarFilling.visible = false

	$Shield/AnimatedSprite2D.modulate = Color(1,1,1,1)

func _on_timer_timeout():
	$Timer.stop()
	shield = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Shield/CollisionShape2D.set_deferred("disabled", false)
	shield = true
	$Shield2.play()
	$Shield/AnimatedSprite2D.visible = true


	


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "dmg":
		await get_tree().create_timer(0.2).timeout
		if $AnimatedSprite2D: $AnimatedSprite2D.animation = "default"


func _on_shield_body_entered(body):
	if body.is_in_group("player"):
		body.die()
		



func _on_shield_area_entered(area):
	if area.is_in_group("explosion") or area.is_in_group("lightning"):
		shield = false
		$Shield/AnimatedSprite2D.visible = false
		$Shield/CollisionShape2D.set_deferred("disabled", true)
		$Shield/ExplosionParticles.emitting = true
		$Shield/ExplosionParticles.emitting = false
		await get_tree().create_timer(0.5).timeout
		$CollisionShape2D.set_deferred("disabled", false)
		$Timer.start()
		
