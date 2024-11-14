extends Node2D

func _ready() -> void:
	$tux2.get_child(0).gravity_scale = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("yep")
		$AudioStreamPlayer2D.play()
		gv.playernode.cam_zoom_override = 0.7
		gv.can_fire = false
		$tux2.get_child(0).gravity_scale = 1

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "tux2":
		$Area2D.monitoring = false
		gv.playernode.cam_zoom_override = 0
		gv.can_fire = true
