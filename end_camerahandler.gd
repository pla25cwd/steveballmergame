extends Node

var active = false # free spaghet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	gv.playernode.n_camera.position_smoothing_speed = lerpf(gv.playernode.n_camera.position_smoothing_speed, 10, 0.0005)
	if active:
		if gv.playernode.n_camera.global_position.y > -12223:
			gv.playernode.n_camera.global_position.y = gv.playernode.global_position.y
			print("to player")
		elif gv.playernode.n_camera.global_position.y < -12223:
			gv.playernode.n_camera.global_position.y = -12223
			print("overcorrect")
