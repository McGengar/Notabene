extends Node2D

var time =0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if time>1:
		$Node2D/Player/Camera2D.zoom.x= lerpf($Node2D/Player/Camera2D.zoom.x, 4, 2*delta)
		$Node2D/Player/Camera2D.zoom.y= lerpf($Node2D/Player/Camera2D.zoom.y, 4, 2*delta)


func _on_timer_timeout():
	time+=1
