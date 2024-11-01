extends Node2D

@onready var camera = $Camera2D
@onready var player1 = $player
@onready var player2 = $player2

func _physics_process(delta: float) -> void:

	
	camera.global_position = (player1.global_position + player2.global_position)/2


func _on_visible_on_screen_notifier_2d_3_screen_exited() -> void:
	camera.zoom -= Vector2(0.5, 0.5)
