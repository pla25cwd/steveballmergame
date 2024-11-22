extends Node2D

var filepath

func _on_file_dialog_canceled() -> void:
	queue_free()

func _on_file_dialog_file_selected(path: String) -> void:
	filepath = path
