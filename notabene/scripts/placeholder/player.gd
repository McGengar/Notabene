extends RigidBody2D

@export var crystal : PackedScene
@export var magma : PackedScene
@export var movement_speed : float = 75
@export var dash_strength : float = 3000
@export var player_direction: Vector2 = Vector2(-1,0)
var character_direction : Vector2
var dashes : int = 1
var is_dashing : bool = false
var can_absorb : bool = true

var element1 : String = "none"
var element2 : String = "none"

var r_str = 10.0
var shake_fade = 5.0
var rng = RandomNumberGenerator.new()
var shake_str = 0

var dash_cooldown = 0.85
var cooldown1 = 1
var cooldown2 = 0
var cooldown3 = 0
var cooldown4 = 0

var buff1 = 1
var buff2 = 1
var buff3 = 1

var buff_free1 = true
var buff_free2 = true
var buff_free3 = true

var mud_placed = false

var storm = false
var locked_in = false

var emitting_magma = false

var shield = false
var shield_duration = 0

var golden_skill = false

var air_dash_duration = 10

var mud_slow = 4

var alive = true
var camera_zoom = 4.0

signal dies

var abilities = [
	"temporary agility",
	"destruction on demand",
	"swing and slash",
	"trail of burn",
	"empowered dash",
	"enhancement of next ability",
	"mass area slow, stops electricity",
	"field of destruction",
	"throwing riches all around",
	"temporary invincibility"
]

var fading_in = false
var alpha = 0

func big_enemy_dmg(body,dmg):
	body.hp-=dmg
	if body.hp<=0:
		$Sounds/BigEnemyDeathSound.play()
		destroy_enemy(body)
	else:
		$Sounds/EnemyDeathSound.pitch_scale = randf_range(0.95,1.05)
		$Sounds/EnemyDeathSound.play()
		if body:body.get_node("CPUParticles2D").emitting = true
		if body:body.get_node("CPUParticles2D").emitting = false
		if get_node("AnimatedSprite2D")!=null:body.get_node("AnimatedSprite2D").play("dmg")
		
func die():
	if alive:
		if shield ==true:
			$Shield/CollisionShape2D.set_deferred("disabled", false) 
			$Shield/ExplosionParticles.emitting = true
			$Shield/AnimatedSprite2D2.visible = false
			camera_shake()
			$Shield/Timer.start()
		else:
			if $Plasma/ExplosionParticles2.emitting ==true:
				$Plasma/ExplosionParticles2.emitting =false
				$Plasma.monitoring=false
			$Sounds/DeathSound.play()
			$Sounds/DeathSound2.play()
			if $"../AudioStreamPlayer2D": $"../AudioStreamPlayer2D".stop()
			if $"../AudioStreamPlayer2D2": $"../AudioStreamPlayer2D2".stop()
			if $"../AudioStreamPlayer2D3": $"../AudioStreamPlayer2D3".stop()
			alive = false
			dashes = 0
			element1="none"
			camera_shake()
			$Area2D.monitorable=false
			$Area2D.monitoring=false
			if $SkillParticles : $SkillParticles.emitting = false
			if $CollisionShape2D: $CollisionShape2D.free()
			if $CPUParticles2D: $CPUParticles2D.emitting = false
			if $AnimatedSprite2D: $AnimatedSprite2D.free()
			if $IdleParticles: $IdleParticles.emitting = false
			if $IdleParticles2: $IdleParticles2.emitting = false
			$DeathParticles.emitting= true
			if $Area2D/CollisionShape2D: $Area2D/CollisionShape2D.free()
			await get_tree().create_timer(2).timeout
			dies.emit()
			get_tree().reload_current_scene()

func camera_shake(str = r_str):
	shake_str=str
func random_offset():
		return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))

func destroy_enemy(body):
	$Sounds/EnemyDeathSound.pitch_scale = randf_range(0.95,1.05)
	$Sounds/EnemyDeathSound.play()
	if body.get_node("AnimatedSprite2D"): body.get_node("AnimatedSprite2D").free()
	if body.get_node("CollisionShape2D"): body.get_node("CollisionShape2D").set_deferred("disabled", true)
	if body.get_node("CollisionShape2D"): body.get_node("CollisionShape2D").free()
	if body.get_node("CPUParticles2D"): body.get_node("CPUParticles2D").emitting = true
	if body.get_node("CPUParticles2D2"): body.get_node("CPUParticles2D2").emitting = false
	await get_tree().create_timer(0.5).timeout
	if body!=null: body.free()

func slash():
	$slash/CollisionShape2D2/slash_sprite.visible=true
	$slash/CollisionShape2D2/slash_sprite.play("default")
	$slash/CollisionShape2D2.disabled =false
	locked_in = true
	camera_shake(25)
	$Sounds/Sword.play()
	if golden_skill:
		$slash.scale *= 1.5
		
	await get_tree().create_timer(0.15).timeout		
	locked_in = false
	$slash/CollisionShape2D2/slash_sprite.stop()
	$slash/CollisionShape2D2/slash_sprite.frame=0
	if golden_skill:
		$slash/CollisionShape2D2.disabled =true
		locked_in = true
		camera_shake(30)
		$slash/CollisionShape2D2.disabled =false
		$slash/CollisionShape2D2/slash_sprite.play("default")
		await get_tree().create_timer(0.15).timeout	
		locked_in = false
		$slash/CollisionShape2D2/slash_sprite.stop()
		$slash/CollisionShape2D2/slash_sprite.frame=0
		$slash.scale /= 1.5
		$CanvasLayer/Skill.modulate = Color(1,1,1,1)
		golden_skill = false
	
	$slash/CollisionShape2D2/slash_sprite.visible=false
	$slash/CollisionShape2D2.disabled = true

func _ready():
	$Sounds/LeveLTransition.play()
	if true:
		element1 = "none"
		element2 = "none"
		$CanvasLayer/CurrentElement1.visible = false
		$CPUParticles2D.color_ramp.set_color(0,Color(0,0,0,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0,0,0,0))
		$IdleParticles.color = Color(0,0,0)
		$IdleParticles.hue_variation_min = -0.3
		$Aborb.color = Color(0,0,0)
		$Aborb.radial_accel_min = 100
		$Aborb.radial_accel_max = 150
		$Aborb.emission_sphere_radius = 25
		$Aborb.emitting = true
		$IdleParticles2.emitting = false
		$IdleParticles.radial_accel_min = 0
		$IdleParticles.radial_accel_max = 0
		await get_tree().create_timer(0.1).timeout
		$Aborb.emitting = false
		await get_tree().create_timer(0.5).timeout
		$Aborb.emission_sphere_radius = 50
		$Aborb.radial_accel_min = -1000
		$Aborb.radial_accel_max = -1000
	
	shield =false
	$Shield/Timer.stop()
	$CPUParticles2D.emitting = false
	collision_mask = 5
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, true)
	is_dashing = false
	can_absorb = true
	$Aborb.emitting = false
	$CanvasLayer/Skill.visible = false
	$CanvasLayer/CurrentElement1.visible = false
	
func change_element(element):
	$Sounds/ElementSound.pitch_scale=1
	$Sounds/ElementSound.play()
	element1 = element
	if element!="none" : $CanvasLayer/Skill.visible = true
	match element:
		"none":
			if $AnimatedSprite2D:
				$CanvasLayer/CurrentElement1.visible = false
				$CPUParticles2D.color_ramp.set_color(0,Color(0,0,0,1))
				$CPUParticles2D.color_ramp.set_color(1,Color(0,0,0,0))
				$IdleParticles.color = Color(0,0,0)
				$IdleParticles.hue_variation_min = -0.3
				$Aborb.color = Color(0,0,0)
				$Aborb.radial_accel_min = 100
				$Aborb.radial_accel_max = 150
				$Aborb.emission_sphere_radius = 25
				$Aborb.emitting = true
				$IdleParticles2.emitting = false
				$IdleParticles.radial_accel_min = 0
				$IdleParticles.radial_accel_max = 0
				await get_tree().create_timer(0.1).timeout
				$Aborb.emitting = false
				await get_tree().create_timer(0.5).timeout
				$Aborb.emission_sphere_radius = 50
				$Aborb.radial_accel_min = -1000
				$Aborb.radial_accel_max = -1000
		"fire":
			$CanvasLayer/CurrentElement1.visible = true
			$CanvasLayer/CurrentElement1.frame = 0
			$CPUParticles2D.color_ramp.set_color(0,Color(1,0,0,1))
			$CPUParticles2D.color_ramp.set_color(1,Color(1,0,0,0))
			$IdleParticles.color = Color(1,0,0)
			$IdleParticles.hue_variation_min = -0.15
			$Aborb.color = Color(1,0,0)
			$Aborb.emitting = true
			await get_tree().create_timer(0.2).timeout
			$Aborb.emitting = false
		"water":
			$CanvasLayer/CurrentElement1.visible = true
			$CanvasLayer/CurrentElement1.frame = 1
			$CPUParticles2D.color_ramp.set_color(0,Color(0,0,1,1))
			$CPUParticles2D.color_ramp.set_color(1,Color(0,0,1,0))
			$IdleParticles.color = Color(0,0,1)
			$IdleParticles.hue_variation_min = -0.1
			$Aborb.color = Color(0,0,1)
			$Aborb.emitting = true
			await get_tree().create_timer(0.2).timeout
			$Aborb.emitting = false
		"electric":
			$CanvasLayer/CurrentElement1.visible = true
			$CanvasLayer/CurrentElement1.frame = 2
			$CPUParticles2D.color_ramp.set_color(0,Color(1,1,0,1))
			$CPUParticles2D.color_ramp.set_color(1,Color(1,1,0,0))
			$IdleParticles.color = Color(1,1,0)
			$IdleParticles.hue_variation_min = -0.1
			$Aborb.color = Color(1,1,0)
			$Aborb.emitting = true
			await get_tree().create_timer(0.2).timeout
			$Aborb.emitting = false
		"metal":
			$CanvasLayer/CurrentElement1.visible = true
			$CanvasLayer/CurrentElement1.frame = 3
			$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.7,0.7,1))
			$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.7,0.7,0))
			$IdleParticles.color = Color(0.7,0.7,0.7)
			$IdleParticles.hue_variation_min = 0.0
			$Aborb.color = Color(0.7,0.7,0.7)
			$Aborb.emitting = true
			await get_tree().create_timer(0.2).timeout
			$Aborb.emitting = false
		"earth":
			$CanvasLayer/CurrentElement1.visible = true
			$CanvasLayer/CurrentElement1.frame = 4
			$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.6,0.6,1))
			$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.6,0.6,0))
			$IdleParticles.color = Color(0.7,0.6,0.6)
			$IdleParticles.hue_variation_min = -0.1
			$Aborb.color = Color(0.7,0.6,0.6)
			$Aborb.emitting = true
			await get_tree().create_timer(0.2).timeout
			$Aborb.emitting = false

func fuse_element():
	$Sounds/ElementSound.pitch_scale=1.1
	$Sounds/ElementSound.play()
	#air
	if (element1=="fire" and element2=="water") or (element1=="water" and element2=="fire"):
		element1 = "air"
		element2 = "air"
		$CanvasLayer/CurrentElement1.frame = 5
		$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.7,0.7,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.7,0.7,0))
		$IdleParticles.color = Color(0.7,0.7,0.7)
		$IdleParticles.hue_variation_min = 0.0
		$IdleParticles.radial_accel_min = -150
		$IdleParticles.radial_accel_max = -150
		$Aborb.color = Color(0.7,0.7,0.7)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_air == false:
			Globals.got_air = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[0]+"[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#explosion
	elif (element1=="fire" and element2=="electric") or (element1=="electric" and element2=="fire"):
		element1 = "explosion"
		element2 = "explosion"
		$CanvasLayer/CurrentElement1.frame = 6
		$CPUParticles2D.color_ramp.set_color(0,Color(0.8,0,0,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0,0,0,0))
		$IdleParticles.color = Color(0.9,0,0)
		$IdleParticles.hue_variation_min = -0.2
		$Aborb.color = Color(0.6,0,0)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		$IdleParticles2.emitting = true
		$IdleParticles2.color = Color(0,0,0)
		$IdleParticles2.hue_variation_min = -0.1
		if Globals.got_explosion == false:
			Globals.got_explosion = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[1]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#sword
	elif (element1=="fire" and element2=="metal") or (element1=="metal" and element2=="fire"):
		element1 = "sword"
		element2 = "sword"
		$CanvasLayer/CurrentElement1.frame = 7
		$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.5,0.5,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.5,0.5,0))
		$IdleParticles.color = Color(0.7,0.5,0.5)
		$IdleParticles.hue_variation_min = -0.3
		$"../Sword".visible= true
		$Aborb.color = Color(0.7,0.5,0.5)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_sword == false:
			Globals.got_sword = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[2]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#magma
	elif (element1=="fire" and element2=="earth") or (element1=="earth" and element2=="fire"):
		element1 = "magma"
		element2 = "magma"
		$CanvasLayer/CurrentElement1.frame = 8
		$CPUParticles2D.color_ramp.set_color(0,Color(0.5,0.1,0.1,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.5,0.1,0.1,0))
		$IdleParticles.color = Color(0.4,0.1,0.1)
		$IdleParticles.hue_variation_min = -0.3
		$Aborb.color = Color(0.3,0.1,0.1)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		$IdleParticles2.emitting = true
		$IdleParticles2.color = Color(1,0,0)
		$IdleParticles2.hue_variation_min = -0.1
		if Globals.got_magma == false:
			Globals.got_magma = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[3]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#storm
	elif (element1=="water" and element2=="electric") or (element1=="electric" and element2=="water"):
		element1 = "storm"
		element2 = "storm"
		$CanvasLayer/CurrentElement1.frame = 9
		$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.7,1,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.7,1,0))
		$IdleParticles.color = Color(1,1,0.2)
		$IdleParticles.hue_variation_min = -0.1
		$Aborb.color = Color(1,1,0.2)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		$IdleParticles2.emitting = true
		$IdleParticles2.color = Color(0,0,1)
		$IdleParticles2.hue_variation_min = -0.1		
		if Globals.got_storm == false:
			Globals.got_storm = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[4]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#gold
	elif (element1=="water" and element2=="metal") or (element1=="metal" and element2=="water"):
		element1 = "gold"
		element2 = "gold"
		$CanvasLayer/CurrentElement1.frame = 10
		$CPUParticles2D.color_ramp.set_color(0,Color(0.8,0.8,0,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.8,0.8,0,0))
		$IdleParticles.color = Color(1,1,0.4)
		$IdleParticles.hue_variation_min = -0.2
		$Aborb.color = Color(0.8,0.8,0)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		$IdleParticles2.emitting = true
		$IdleParticles2.color = Color(1,1,1)
		$IdleParticles2.hue_variation_min = -0.1
		if Globals.got_gold == false:
			Globals.got_gold = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[5]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#mud
	elif (element1=="water" and element2=="earth") or (element1=="earth" and element2=="water"):
		element1 = "mud"
		element2 = "mud"
		$CanvasLayer/CurrentElement1.frame = 11
		$CPUParticles2D.color_ramp.set_color(0,Color(0.3,0.2,0.2,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.3,0.2,0.2,0))
		$IdleParticles.color = Color(0.3,0.2,0.2)
		$IdleParticles.hue_variation_min = -0.1
		$Aborb.color = Color(0.3,0.2,0.2)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_mud == false:
			Globals.got_mud = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[6]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#plasma
	elif (element1=="electric" and element2=="metal") or (element1=="metal" and element2=="electric"):
		element1 = "plasma"
		element2 = "plasma"
		$CanvasLayer/CurrentElement1.frame = 12
		$CPUParticles2D.color_ramp.set_color(0,Color(1,0.2,1,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(1,0.2,1,0))
		$IdleParticles.color = Color(1,0.2,1)
		$IdleParticles.hue_variation_min = -0.5
		$Aborb.color = Color(1,0.2,1)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_plasma == false:
			Globals.got_plasma = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[7]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#crystal
	elif (element1=="electric" and element2=="earth") or (element1=="earth" and element2=="electric"):
		element1 = "crystal"
		element2 = "crystal"
		$CanvasLayer/CurrentElement1.frame = 13
		$CPUParticles2D.color_ramp.set_color(0,Color(1,0.4,0.8,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(1,0.4,0.8,0))
		$IdleParticles.color = Color(1,0.4,0.8)
		$IdleParticles.hue_variation_min = -0.1
		$Aborb.color = Color(1,0.4,0.8)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_crystal == false:
			Globals.got_crystal = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[8]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false
	#steel
	elif (element1=="metal" and element2=="earth") or (element1=="earth" and element2=="metal"):
		element1 = "steel"
		element2 = "steel"
		$CanvasLayer/CurrentElement1.frame = 14
		$CPUParticles2D.color_ramp.set_color(0,Color(0.7,0.7,0.7,1))
		$CPUParticles2D.color_ramp.set_color(1,Color(0.7,0.7,0.7,0))
		$IdleParticles.color = Color(0.7,0.7,0.7)
		$IdleParticles.hue_variation_min = 0
		$Aborb.color = Color(0.7,0.7,0.7)
		$Aborb.emitting = true
		await get_tree().create_timer(0.2).timeout
		$Aborb.emitting = false
		if Globals.got_steel == false:
			Globals.got_steel = true
			fading_in = true
			$CanvasLayer/RichTextLabel4.text = "[center]"+element1+"[/center]"
			$CanvasLayer/RichTextLabel5.text = "[center]"+abilities[9]+ "[/center]"
			await get_tree().create_timer(3).timeout
			fading_in = false

func skill(element):
	change_element("none")
	element2="none"
	match element:
		"air":
			$Sounds/Wind.play()
			dash_cooldown = 0.15
			movement_speed = 125
			if golden_skill:
				movement_speed = 150
				air_dash_duration = 15
				golden_skill = false
				$CanvasLayer/Skill.modulate = Color(1,1,1,1)
			cooldown2 = 1
			$SkillParticles.emitting = true
			$SkillParticles.color = Color(1,1,1,1)

		"explosion":
			$Explosion/CollisionShape2D.disabled=false
			$Explosion/ExplosionParticles.emitting= true
			camera_shake(30)
			$Sounds/Explosion.play()
			if golden_skill:
				$Explosion.scale = Vector2(1.5,1.5)
				golden_skill= false
				$CanvasLayer/Skill.modulate = Color(1,1,1,1)
			await get_tree().create_timer(0.2).timeout
			$Explosion.scale = Vector2(1,1)
			$Explosion/ExplosionParticles.emitting= false
			$Explosion/CollisionShape2D.disabled=true
		"sword":
			$"../Sword".visible=false
			slash()	
		"magma":
			emitting_magma = true
			$Sounds/Magma.play()
		"storm":
			storm = true
			if dashes==1:
				$CanvasLayer/Dash2.visible=true
			$Sounds/ThunderSound.play()
			$SkillParticles.emitting = true
			$SkillParticles.color = Color(1,1,0,1)
		"gold":
			golden_skill = true
			$Sounds/Gold.play()
			$CanvasLayer/Skill.modulate = Color(1,1,0,1)
		"mud":
			$Sounds/Magma.play()
			mud_placed = true
			$Mud.visible =true
			$Mud/CollisionShape2D.disabled=false
			cooldown3 = 1
			if golden_skill:
				mud_slow = 10
				golden_skill =false
				await get_tree().create_timer(6).timeout
			else:
				await get_tree().create_timer(4).timeout
			mud_placed = false
			await get_tree().create_timer(0.5).timeout
			$Mud/CollisionShape2D.disabled=true
			$Mud.visible= false
			await get_tree().create_timer(0.5).timeout
			mud_slow = 4
		"plasma":
			$Sounds/Plasma.play()
			cooldown4 = 1
			$Plasma/CollisionShape2D.disabled= false
			$Plasma/ExplosionParticles2.emitting = true
			if golden_skill:
				golden_skill=false
				$CanvasLayer/Skill.modulate = Color(1,1,1,1)
				$Plasma.scale*=1.2
				for n in range(25):
						$Plasma/CollisionShape2D.disabled= false
						await get_tree().create_timer(0.1).timeout
						$Plasma/CollisionShape2D.disabled= true
						await get_tree().create_timer(0.1).timeout
				$Plasma.scale/=1.2
			else:
				for n in range(15):
						$Plasma/CollisionShape2D.disabled= false
						await get_tree().create_timer(0.1).timeout
						$Plasma/CollisionShape2D.disabled= true
						await get_tree().create_timer(0.1).timeout
			$Plasma/ExplosionParticles2.emitting = false
			$Plasma/CollisionShape2D.disabled= true
		"crystal":
			var crystal_dir : PackedVector2Array = [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0), Vector2(1,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1)]
			
			var num = 8
			$Sounds/Crystal.play()
			for n in range(8):
				var bullet = crystal.instantiate()
				get_parent().add_child(bullet)
				bullet.transform = transform
				if golden_skill:
					bullet.scale *=1.5
				bullet.rotation = deg_to_rad(45)*n
				bullet.player_direction = crystal_dir[n]
			if golden_skill:
				for x in range(2):
					await get_tree().create_timer(0.25).timeout
					for n in range(8):
						var bullet = crystal.instantiate()
						get_parent().add_child(bullet)
						bullet.transform = transform
						if golden_skill:
							bullet.scale *=1.5
						bullet.rotation = deg_to_rad(45)*n
						bullet.player_direction = crystal_dir[n]
					
				golden_skill = false
				$CanvasLayer/Skill.modulate = Color(1,1,1,1)
			
		"steel":
			$Sounds/Shield.play()
			shield = true
			shield_duration = 12
			if golden_skill:
				shield_duration = 20
				golden_skill = false
				$CanvasLayer/Skill.modulate = Color(1,1,1,1)
			$Shield/AnimatedSprite2D2.visible=true
	

func dash():
	cooldown1 = -0.15
	dashes=0
	$CanvasLayer/Dash.material.set("shader_parameter/cooldown_progress", 0)
	$CPUParticles2D.emitting = true
	#$Area2D.monitoring = true
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	is_dashing = true
	$Sounds/DashSound.pitch_scale = randf_range(0.95,1.05)
	$Sounds/DashSound.play()
	$Area2D/CollisionShape2D.shape.radius = 5
	$Area2D/CollisionShape2D.shape.height = 15
	await get_tree().create_timer(0.30).timeout
	$Area2D/CollisionShape2D.shape.radius = 3
	$Area2D/CollisionShape2D.shape.height = 11
	$CPUParticles2D.emitting = false
	#$Area2D.monitoring = false
	collision_mask = 5
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, true)
	is_dashing = false
	can_absorb = true
	
	if storm:
		$Sounds/ThunderSound2.play()
		storm = false
		$CanvasLayer/Dash2.visible=false
		$"../Lightning/AnimatedSprite2D".visible= true
		$"../Lightning/AnimatedSprite2D".play("default")
		$"../Lightning/CollisionShape2D".disabled=false
		camera_shake()
		if golden_skill:
			$"../Lightning".scale*=1.5
		$CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0.3)
		await get_tree().create_timer(0.05).timeout
		camera_shake(30)
		$"../Lightning/CPUParticles2D".emitting=true
		await get_tree().create_timer(0.05).timeout
		$CanvasLayer/Sprite2D.material.set("shader_parameter/noise_amount", 0)
		if golden_skill:
			$"../Lightning".scale/=1.5
			golden_skill=false
			$CanvasLayer/Skill.modulate = Color(1,1,1,1)
		$"../Lightning/AnimatedSprite2D".visible= false
		$"../Lightning/AnimatedSprite2D".stop()
		$"../Lightning/AnimatedSprite2D".frame=0
		$"../Lightning/CollisionShape2D".disabled=true
		$SkillParticles.emitting = false
		await get_tree().create_timer(dash_cooldown-0.1).timeout
	else:
		await get_tree().create_timer(dash_cooldown).timeout
	dashes=1
	if storm:
		$CanvasLayer/Dash2.visible=true

func _physics_process(delta):
	
	
	if fading_in and alpha<1:
		alpha += 4*delta
	elif fading_in==false and alpha > 0:
		alpha -= 2*delta
	$CanvasLayer/RichTextLabel4.modulate = Color(1,1,1,alpha)
	$CanvasLayer/RichTextLabel5.modulate = Color(1,1,1,alpha)
	
	if element1 == "none":
		$CanvasLayer/RichTextLabel.text=""
	else:
		$CanvasLayer/RichTextLabel.text="[center]"+element1+"[/center]"
	
	if element1 == "none":
		$CanvasLayer/RichTextLabel3.text=""
	elif element2 == "none":
		$CanvasLayer/RichTextLabel3.text="[center]free[/center]"
	else:
		$CanvasLayer/RichTextLabel3.text="[center]skill[/center]"
	
	if shake_str>0:
		shake_str = lerpf(shake_str,0,shake_fade*delta)
		$Camera2D.offset=random_offset()
	$CanvasLayer/Dash.material.set("shader_parameter/cooldown_progress", cooldown1-0.25)
	cooldown1 += delta/dash_cooldown
	
	cooldown2 -= delta/air_dash_duration
	
	if shield_duration>0:
		shield_duration-=delta
		$Shield/AnimatedSprite2D2.modulate = Color(1,1,1,(shield_duration/20))
	if shield_duration <=0:
		shield = false
		$Shield/AnimatedSprite2D2.modulate = Color(1,1,1,0)
		
	if cooldown2<0:
		dash_cooldown = 0.85
		$SkillParticles.emitting = false
		movement_speed = 100
		air_dash_duration = 10
	cooldown3 -= delta/4
	cooldown4 -= delta/3
	
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	character_direction = character_direction.normalized()
	
	if emitting_magma:
		var times = 25
		emitting_magma = false
		if golden_skill:
			times = 40
			golden_skill = false
			$CanvasLayer/Skill.modulate = Color(1,1,1,1)
		for n in range(times):
			var puddle = magma.instantiate()	
			puddle.transform = transform
			await get_tree().create_timer(0.05).timeout
			get_parent().add_child(puddle)
			await get_tree().create_timer(0.05).timeout
		times = 25

	if Input.is_action_pressed("move_up"): 
		if !locked_in : $slash.rotation = deg_to_rad(-90)
		player_direction= Vector2(0,-1)
	if Input.is_action_pressed("move_down"): 
		if !locked_in : $slash.rotation = deg_to_rad(90)
		player_direction= Vector2(0,1)
	if Input.is_action_pressed("move_right"): 
		if !locked_in : $slash.rotation = deg_to_rad(0)
		player_direction= Vector2(1,0)
	if Input.is_action_pressed("move_left"): 
		if !locked_in : $slash.rotation = deg_to_rad(-180)
		player_direction= Vector2(-1,0)
	
	if mud_placed:
		$Mud.scale = lerp($Mud.scale, Vector2(12,12), 0.1)
	if !mud_placed and $Mud.scale.x>0:
		$Mud.scale -= Vector2(12,12)*delta*2
	#apply_central_impulse(character_direction * movement_speed * delta)
	if $AnimatedSprite2D: apply_central_force(character_direction*movement_speed*1000*delta)
	
	if Input.is_action_just_pressed("dash") and dashes>0 and alive:
		dash()
		apply_central_force(player_direction*dash_strength*1000*delta)

	if Input.is_action_just_pressed("reset"):
		die()
	
	if Input.is_action_just_pressed("skill") and is_dashing == false and element1!="none" and element2=="none":
		$CanvasLayer/Skill.visible = false
		camera_shake()
		change_element("none")
		element2 = "none"
	elif Input.is_action_just_pressed("skill") and is_dashing == false and element2!="none":
		$CanvasLayer/Skill.visible = false
		camera_shake()
		skill(element1)
		
	$CanvasLayer/speed_x.text = str(abs(int(linear_velocity.x)))
	$CanvasLayer/speed_y.text = str(abs(int(linear_velocity.y)))
	
	if abs(linear_velocity.x)>abs(linear_velocity.y):
		camera_zoom =lerp(camera_zoom,4.0-clamp(abs(linear_velocity.x)*100, 0.0, 140.0)/164.0, 0.05)
	else:
		camera_zoom =lerp(camera_zoom,4.0-clamp(abs(linear_velocity.y)*100, 0.0, 140.0)/164.0, 0.05)
	$Camera2D.zoom = Vector2(camera_zoom,camera_zoom)
	
#collision
func _on_area_2d_body_entered(body):
	if (body.is_in_group("enemy") or body.is_in_group("big_enemy")) and is_dashing==false:
		die()
	elif body.is_in_group("enemy"):
		if body.is_in_group("fire_enemy") and $CPUParticles2D.emitting == true:
			camera_shake()
			if element1=="none" and can_absorb:
				change_element("fire")
				can_absorb = false
			elif element1!="none" and element2=="none" and can_absorb and element1!="fire":
				element2 = "fire"
				fuse_element()
			destroy_enemy(body)
		elif body.is_in_group("water_enemy") and $CPUParticles2D.emitting == true:
			camera_shake()
			if element1=="none" and can_absorb:
				change_element("water")
				can_absorb = false
			elif element1!="none" and element2=="none" and can_absorb and element1!="water":
				element2 = "water"
				fuse_element()
			destroy_enemy(body)
		elif body.is_in_group("electric_enemy") and $CPUParticles2D.emitting == true:
			camera_shake()
			if element1=="none" and can_absorb:
				change_element("electric")
				can_absorb = false
			elif element1!="none" and element2=="none" and can_absorb and element1!="electric":
				element2 = "electric"
				fuse_element()
			destroy_enemy(body)
		elif body.is_in_group("metal_enemy") and $CPUParticles2D.emitting == true:
			camera_shake()
			if element1=="none" and can_absorb:
				change_element("metal")
				can_absorb = false
			elif element1!="none" and element2=="none" and can_absorb and element1!="metal":
				element2 = "metal"
				fuse_element()
			destroy_enemy(body)
		elif body.is_in_group("earth_enemy") and $CPUParticles2D.emitting == true:
			camera_shake()
			if element1=="none" and can_absorb:
				change_element("earth")
				can_absorb = false
			elif element1!="none" and element2=="none" and can_absorb and element1!="earth":
				element2 = "earth"
				fuse_element()
			destroy_enemy(body)
	elif body.is_in_group("big_enemy"):	
		big_enemy_dmg(body,10)
		camera_shake(15)


func _on_slash_body_entered(body):
	if body.is_in_group("enemy"):
		destroy_enemy(body)
	if body.is_in_group("big_enemy"):
		big_enemy_dmg(body,50)
		camera_shake(35)


func _on_explosion_body_entered(body):
	if body.is_in_group("enemy"):
		destroy_enemy(body)
	if body.is_in_group("big_enemy"):
		big_enemy_dmg(body,50)
		camera_shake(30)
		if body.is_in_group("earth_enemy"):
			big_enemy_dmg(body,100)
		if $Explosion.scale == Vector2(1.5,1.5):
			big_enemy_dmg(body,25)
			camera_shake(40)
			if body.is_in_group("earth_enemy"):
				big_enemy_dmg(body,100)


func _on_mud_body_entered(body):
	if body.is_in_group("enemy"):
		body.movement_speed/=mud_slow
		if body.is_in_group("electric_enemy"):
			destroy_enemy(body)
	elif body.is_in_group("big_enemy") and body.is_in_group("electric_enemy"):
		big_enemy_dmg(body,100)
	elif body.is_in_group("big_enemy"):
		body.movement_speed/=mud_slow

func _on_mud_body_exited(body):
	if body.is_in_group("enemy") or body.is_in_group("big_enemy"):
		body.movement_speed*=mud_slow
		


func _on_plasma_body_entered(body):
	if body.is_in_group("enemy"):
		destroy_enemy(body)
	if body.is_in_group("big_enemy"):
		big_enemy_dmg(body,10)
		camera_shake(8)


func _on_lightning_body_entered(body):
	if body.is_in_group("enemy") and !body.is_in_group("electric_enemy"):
		destroy_enemy(body)
	if body.is_in_group("big_enemy") and !body.is_in_group("electric_enemy"):
		big_enemy_dmg(body,100)
		camera_shake(40)
		if body.is_in_group("water_enemy"):
			big_enemy_dmg(body,100)




func _on_timer_timeout():
	shield = false
	$Shield/CollisionShape2D.set_deferred("disabled", true) 
	$Shield/ExplosionParticles.emitting = false
	

func _on_shield_body_entered(body):
	if body.is_in_group("enemy"):
		destroy_enemy(body)
	if body.is_in_group("big_enemy"):
		camera_shake(25)
		big_enemy_dmg(body,10)

func _on_area_2d_area_entered(area):
	if area.is_in_group("big_enemy") and is_dashing==false:
		die()
	elif area.is_in_group("enemy_shield") and is_dashing==false:
		die()
		
func _on_area_2d_area_exited(area):
	if area.is_in_group("big_enemy") and is_dashing==false:
		die()
	elif area.is_in_group("enemy_shield") and is_dashing==false:
		die()


func _on_area_2d_body_exited(body):
	if body.is_in_group("big_enemy") and is_dashing==false:
		die()
