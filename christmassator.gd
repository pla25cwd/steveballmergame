extends Node2D

@export var hide : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_in_group("christmassiers"):
		add_to_group("christmassiers")
	
	visible = hide

func c_activate():
	visible = !hide
