@tool
extends Node2D

@export var shape : Shape2D = CircleShape2D.new() :
	set(value):
		shape = value
		update_coll(value)

@export var disable_after : bool = true

func update_coll(shape):
	if get_child_count() != 0:
		$Area2D/CollisionShape2D.shape = shape
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gv.audiohandler.play_random()
		if disable_after:
			queue_free()

func audiohandler_disabled():
	queue_free()
