extends Sprite2D

# checks for christmas, does not yet control jesus christ

var noise

func _ready() -> void:
	noise = get_texture().get_noise()
	visible = false
	if Time.get_date_dict_from_system()["month"] == 12:
		get_tree().call_group("christmassiers", "activate")

func activate():
	visible = true

func _physics_process(delta: float) -> void:
	if visible:
		noise.offset += Vector3(0.1,-0.1,0)
