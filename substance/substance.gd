extends Area2D

@onready var sprite = $AnimatedSprite2D
var spriteframe : int

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !body.ballmer_on_crack:
			gv.playernode.substance_pickup()
			$AnimationPlayer.play("pickup")

func new_frame():
	spriteframe = sprite.frame
	while spriteframe == sprite.frame:
		sprite.frame = randi_range(0,9)

func _on_onscreen_screen_entered() -> void:
	if gv.vistas < get_parent().get_meta("MIN_VISTAS") or gv.wphones < get_parent().get_meta("MIN_WPHONES"):
		get_parent().queue_free()
