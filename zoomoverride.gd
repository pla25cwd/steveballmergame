@tool
extends Node2D

@export var shape : Shape2D = CircleShape2D.new() :
	set(value):
		shape = value
		update_coll(value)
		
@export var zoom_amount : float = 1

func update_coll(shape):
	if $Area2D2/CollisionShape2D != null:
		$Area2D2/CollisionShape2D.shape = shape
		
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.cam_zoom_override = zoom_amount

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == "player":
		body.cam_zoom_override = 0
