extends RigidBody2D

@onready var anim = $AnimationPlayer

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		gv.playernode.apply_central_impulse(gv.playernode.global_position.direction_to(global_position) * -500)
		anim.play("new_animation")

func _on_onscreen_screen_entered() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS
	$onscreen.enable_node_path = ""
