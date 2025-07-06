extends CanvasLayer

var req
var req_body

var replay_head : Dictionary
var replay_pos : PackedVector4Array = []
var replay_sit : PackedVector4Array = []
var replay_active = true
var replay_pos_tmpvec
var replay_sit_tmpvec
var replay_fcheck : bool = false
var finalized_replay : String

@onready var feedback = $feedback
@onready var http_feedback = $feedback/http_feedback
@onready var feedback_le = $feedback/PanelContainer/MarginContainer/VBoxContainer/feedback_le
@onready var feedback_tr = $feedback/PanelContainer/MarginContainer/VBoxContainer/TextureRect
var caret_le
var caret_word
var regex

@onready var n_results = $results


func _ready() -> void:
	gv.nethand = self
	feedback.visible = false
	
	regex = RegEx.new()
	regex.compile('([a-zA-Z0-9 _]+)')
	
func _physics_process(delta: float) -> void:
	if feedback.visible:
		if !feedback_le.has_focus():
			feedback_le.grab_focus()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("f1"):
		if feedback.visible:
			return
		feedback_tr.texture = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
		feedback.visible = true
		$AudioStreamPlayer.play()
		gv.nh_open = true

func _on_feedback_le_gui_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_ESCAPE):
		if feedback_le.text == "chrimbus":
			get_tree().call_group("christmassiers", "c_activate")
		
		if feedback_le.text == "antichrimbus":
			get_tree().call_group("christmassiers", "c_deactivate")
		
		if feedback_le.text == "zumkotzn":
			gv.playernode.n_camera.ignore_rotation = false
			gv.playernode.n_camera.position_smoothing_enabled = false
			
		if feedback_le.text == "debug_rplsv":
			finalize_replay(false)
			JavaScriptBridge.download_buffer(finalized_replay.to_utf8_buffer(), "replay.bsr2005")
		
		if feedback_le.text == "debug_tuxtp":
			gv.playernode.freeze = true
			gv.playernode.set_deferred("global_position", Vector2(-5150, -3250))
			gv.playernode.freeze = false
		
		if feedback_le.text == "debug_fuckingkill1":
			$"../tuxbattle/env_anim".play("drop_wphones")
			
		if feedback_le.text == "debug_fuckingkill2":
			$"../tuxbattle/env_anim".play("drop_vistas")
		
		feedback_le.text = ""
		feedback.visible = false
		gv.nh_open = false

	if Input.is_key_pressed(KEY_BACKSPACE):
		feedback_le.delete_char_at_caret()

func _on_button_pressed() -> void:
	feedback_le.text = ""
	feedback.visible = false
	gv.nh_open = false

func finalize_replay(stop : bool):
	if stop:
		replay_active = false
		$Timer.stop()
	
	finalized_replay = Marshalls.variant_to_base64(replay_pos) + "\n" + Marshalls.variant_to_base64(replay_sit)
	
func _on_timer_timeout() -> void:
	if replay_active:
		replay_pos_tmpvec = Vector4.ZERO
		replay_pos_tmpvec.x = gv.playernode.global_position.x
		replay_pos_tmpvec.y = gv.playernode.global_position.y
		replay_pos_tmpvec.z = gv.playernode.global_rotation_degrees
		replay_pos_tmpvec.w = gv.playernode.n_rotation.global_rotation_degrees
		replay_pos.append(replay_pos_tmpvec)
		
		replay_sit_tmpvec = Vector4.ZERO
		replay_sit_tmpvec.x = gv.encode_float32arr([replay_fcheck, gv.playernode.b2loaded])
		replay_sit.append(replay_sit_tmpvec)

		replay_fcheck = false

func _on_feedback_le_text_changed(new_text: String) -> void:
	caret_le = feedback_le.caret_column

	caret_word = ""
	for i in regex.search_all(new_text):
		caret_word += i.get_string()
	
	feedback_le.text = caret_word
	feedback_le.caret_column = caret_le
