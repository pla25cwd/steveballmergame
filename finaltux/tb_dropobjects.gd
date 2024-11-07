extends RigidBody2D

@export var vista : bool = false

func _ready() -> void:
	if vista:
		$Sprite2D.scale = Vector2(0.3, 0.3)
		$Sprite2D.animation = "vista"

	$Sprite2D.frame = randi_range(0, $Sprite2D.get_sprite_frames().get_frame_count($Sprite2D.animation)) # ewwwwwww

func _on_timer_timeout() -> void:
	queue_free()

func die():
	freeze = true # TODO: magically doesnt work
	$Sprite2D2.visible = true
	$Sprite2D.visible = false
	$Timer.start()
