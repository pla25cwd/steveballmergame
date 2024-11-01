extends RigidBody2D

@onready var anim = $AnimationPlayer

func _on_onscreen_screen_entered() -> void:
	apply_torque(randf_range(-1,1))

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.apply_central_impulse(body.global_position - global_position * 1.15)
		anim.play("new_animation")
