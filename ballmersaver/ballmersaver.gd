extends Node2D

@onready var raycast = $RayCast2D
@onready var anim = $AnimationPlayer
@onready var bonzi = $Path2D/PathFollow2D/AnimatableBody2D
@onready var path :Path2D = $Path2D
var player_node : RigidBody2D

func _physics_process(delta: float) -> void:
	if raycast.is_colliding() and raycast.get_collider().name == "player":
		player_node = raycast.get_collider()
		raycast.enabled = false
		player_node.cam_zoom_override = 1
		print("yep")
		anim.play("ballmersaved")

func go_to_player():
	path.get_curve().set_point_position(0, player_node.global_position - position - Vector2(0,100))
	path.get_curve().set_point_position(1, player_node.global_position - position + Vector2(0,1000))


func reset_zoom_override():
	player_node.cam_zoom_override = 0
