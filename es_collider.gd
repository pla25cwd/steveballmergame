extends Node2D

@export var type : String

func _ready() -> void:
	$AnimatedSprite2D.animation = type
	$AnimatedSprite2D.frame = randi_range(0, $AnimatedSprite2D.get_sprite_frames().get_frame_count(type))
	if type == "vista":
		$AnimatedSprite2D.scale = Vector2(0.3,0.3)
