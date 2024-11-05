extends Node2D

var player

func _ready() -> void:
	$tux2.get_child(0).gravity_scale = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		print("yep")
		player.cam_zoom_override = 0.7
		gv.can_fire = false
		$tux2.get_child(0).gravity_scale = 1
		$tux2.get_child(0).apply_torque_impulse(50)

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "tux2":
		$Area2D.monitoring = false
		player.cam_zoom_override = 0
		gv.can_fire = true
