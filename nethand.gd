extends CanvasLayer

var req
var req_body

var replay : PackedVector4Array = [Vector4.ZERO] # mouse pos x, mouse pos y, frame n, reserved
var replay_active = true
var replay_tmpvec

@onready var feedback = $feedback
@onready var http_feedback = $feedback/http_feedback
@onready var feedback_le = $feedback/PanelContainer/MarginContainer/VBoxContainer/feedback_le
@onready var feedback_tr = $feedback/PanelContainer/MarginContainer/VBoxContainer/TextureRect

@onready var n_results = $results

func _ready() -> void:
	gv.nethand = self
	feedback.visible = false

func _physics_process(delta: float) -> void:
	if feedback.visible:
		if !feedback_le.has_focus():
			feedback_le.grab_focus()
	
func feedback_req(message):
	req = {}
	var req_image = get_viewport().get_texture().get_image()
	req["image_data"] = Array(req_image.save_png_to_buffer())
	req["image_width"] = req_image.get_width()
	req["image_height"] = req_image.get_height()
	req["image_format"] = req_image.get_format()
	req["message"] = message
	req["unixtime"] = roundi(Time.get_unix_time_from_system())
	
	req_body = JSON.stringify(req)
	http_feedback.request("http://172.16.139.69:5000/feedback", ["Content-Type: application/json"], HTTPClient.METHOD_POST, req_body)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("f1"):
		if feedback.visible:
			return
		feedback_tr.texture = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
		feedback.visible = true
		$AudioStreamPlayer.play()
		gv.nh_open = true

func _on_feedback_le_gui_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		if feedback_le.text == "chrimbus":
			get_tree().call_group("christmassiers", "c_activate")
			
		if feedback_le.text == "zumkotzn":
			gv.playernode.n_camera.ignore_rotation = false
			gv.playernode.n_camera.position_smoothing_enabled = false
			
		if feedback_le.text == "debug_rplsv":
			$dbsv.show()
		
		feedback_le.text = ""
		feedback.visible = false
		gv.nh_open = false

	if Input.is_key_pressed(KEY_BACKSPACE):
		feedback_le.delete_char_at_caret()

	if Input.is_key_pressed(KEY_ENTER):
		feedback.visible = false
		await RenderingServer.frame_post_draw
		feedback_req(feedback_le.text)
		feedback_le.text = ""
		gv.nh_open = false

func _on_button_pressed() -> void:
	feedback_le.text = ""
	feedback.visible = false
	gv.nh_open = false

func finish_replay():
	replay_active = false
	$Timer.stop()
	
func save_replayfile(filepath):
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(var_to_str(replay))
	
func upload_replayfile(name):
	req = {}
	req["replay"] = var_to_str(replay)
	req["name"] = name
	req["wphones"] = gv.wphones
	req["vistas"] = gv.vistas
	req["time"] = gtime.value
	req["unixtime"] = roundi(Time.get_unix_time_from_system())
	
	req_body = JSON.stringify(req)
	http_feedback.request("http://172.16.139.69:5000/upload", ["Content-Type: application/json"], HTTPClient.METHOD_POST, req_body)

func _on_timer_timeout() -> void:
	if replay_active:
		replay_tmpvec = Vector4.ZERO
		replay_tmpvec.x = gv.playernode.global_position.x
		replay_tmpvec.y = gv.playernode.global_position.y
		replay_tmpvec.z = gv.playernode.global_rotation_degrees
		replay_tmpvec.w = gv.playernode.n_rotation.global_rotation_degrees
		replay.append(replay_tmpvec)


func _on_dbsv_file_selected(path: String) -> void:
	save_replayfile(path)
