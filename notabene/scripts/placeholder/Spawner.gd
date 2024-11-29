extends Node2D

@onready var fire_enemy = load("res://scenes/enemy.tscn")
@onready var water_enemy = load("res://scenes/enemy_water.tscn")
@onready var electric_enemy = load("res://scenes/enemy_electric.tscn")
@onready var metal_enemy = load("res://scenes/enemy_metal.tscn")
@onready var earth_enemy = load("res://scenes/enemy_earth.tscn")
@onready var big_fire_enemy = load("res://scenes/big_fire_enemy.tscn")
@onready var big_water_enemy = load("res://scenes/big_water_enemy.tscn")
@onready var big_electric_enemy = load("res://scenes/big_electric_enemy.tscn")
@onready var big_metal_enemy = load("res://scenes/big_metal_enemy.tscn")
@onready var big_earth_enemy = load("res://scenes/big_earth_enemy.tscn")

@onready var player = get_node("../../Player")

@export var choice = 0

@export var spawner_color : Color = Color(1,1,1,1)

@export var range = 60

@export var enabled = true

@export var rate = 2.0

signal spawn

var enemies=[]

func _ready():
	$Timer.wait_time = rate
	enemies = [fire_enemy,water_enemy,electric_enemy,metal_enemy,earth_enemy,big_fire_enemy,big_water_enemy,big_electric_enemy,big_metal_enemy,big_earth_enemy]
	$CPUParticles2D2.color = spawner_color



	


func _on_timer_timeout():
	if global_position.distance_to(player.global_position)<range and enabled:
		var instance = enemies[choice].instantiate()
		get_parent().add_child(instance)
		instance.position = $".".global_position
		spawn.emit()
		await get_tree().create_timer(0.1).timeout
		$Timer.wait_time = rate
		$Timer.start()
