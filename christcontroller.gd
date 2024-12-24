extends Sprite2D

# checks for christmas, does not yet control jesus christ

var noise

func _ready() -> void:
	noise = get_texture().get_noise()
	visible = false
	if Time.get_date_dict_from_system()["month"] == 12:
		await RenderingServer.frame_post_draw
		get_tree().call_group("christmassiers", "c_activate")

func c_activate():
	visible = true

func _physics_process(delta: float) -> void:
	if visible:
		noise.offset += Vector3(0.1,-0.1,0)

func c_deactivate():
	visible = false
