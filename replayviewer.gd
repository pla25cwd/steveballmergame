extends Node2D

var replay
var i = 1
var replay_length = 0
var replay_basename : String
var speed_i = 3
var speeds : PackedFloat32Array = [0.1,0.25,0.5,1,1.25,1.5,2,3,5]

var interpolate : bool = true
var follow_player : bool = true
var zoom = 1

@onready var ballmer = $ballmer
@onready var ballmer_rotation = $ballmer/rotation

var tween
var tween_dir_r
var tween_dir_b

@onready var c_filename = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/loader/Panel/filename
@onready var c_fload = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/loader/fload
@onready var c_fd = $CanvasLayer/rvc/FileDialog
@onready var c_playback = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/playback/HBoxContainer2/playback
@onready var c_length = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/playback/HBoxContainer2/length
@onready var c_paused = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/playback/Container/framecontrols/pause
@onready var c_interp = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/settings/interp
@onready var n_cam = $ballmer/Camera2D
@onready var c_time_elapsed = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/time_elapsed
@onready var c_speedsetting = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/playback/Container/speedsetting
@onready var c_currentframe = $CanvasLayer/rvc/rvc_panel/rvc_margin/rvc_vbox/playback/HBoxContainer2/currentframe

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func pause():
	$Timer.stop()
	c_paused.button_pressed = true
	c_paused.icon.region.position.x = 15
	
func unpause():
	if i >= replay_length:
		i = 1
	
	$Timer.start()
	c_paused.button_pressed = false
	c_paused.icon.region.position.x = 0

func load_file(path):
	pause()
	i = 1
	c_filename.text = path.rstrip("/")
	replay_basename = path.get_file().get_basename()
	replay = FileAccess.get_file_as_string(path)
	replay = str_to_var(replay)
	replay_length = replay.size()
	c_playback.max_value = replay_length
	c_length.text = str(replay_length)
	ballmer.global_position.x = replay[1].x
	ballmer.global_position.y = replay[1].y
	ballmer.global_rotation_degrees = replay[1].z
	ballmer_rotation.global_rotation_degrees = replay[1].w

func update() -> void:
	if i >= replay_length:
		pause()
		return
	
	c_currentframe.text = str(i)
	c_time_elapsed.text = Time.get_time_string_from_unix_time(i/10)
	if interpolate:
		tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(ballmer, "global_position", Vector2(replay[i].x, replay[i].y), 0.1/speeds[speed_i]).from_current()
		tween_dir_b = lerp_angle(ballmer.global_rotation, deg_to_rad(replay[i].z), 1)
		tween_dir_r = lerp_angle(ballmer_rotation.global_rotation, deg_to_rad(replay[i].w), 1)
		tween.tween_property(ballmer, "global_rotation_degrees", rad_to_deg(tween_dir_b), 0.1/speeds[speed_i]).from_current()
		tween.tween_property(ballmer_rotation, "global_rotation_degrees", rad_to_deg(tween_dir_r), 0.1/speeds[speed_i]).from_current()
	else:
		ballmer.global_position.x = replay[i].x
		ballmer.global_position.y = replay[i].y
		ballmer.global_rotation_degrees = replay[i].z
		ballmer_rotation.global_rotation_degrees = replay[i].w

func _on_playback_value_changed(value: float) -> void:
	i = value
	update()
	
func _on_paused_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Timer.stop()
		c_paused.icon.region.position.x = 15
	else:
		$Timer.start()
		c_paused.icon.region.position.x = 0

func _on_fload_pressed() -> void:
	c_fd.show()

func _on_file_dialog_file_selected(path: String) -> void:
	load_file(path)

func _on_interp_toggled(toggled_on: bool) -> void:
	interpolate = toggled_on

func _on_timer_timeout() -> void:
	update()
	i += 1
	c_playback.value = i

func _on_follow_toggled(toggled_on: bool) -> void:
	follow_player = toggled_on
	n_cam.top_level = !follow_player
	if toggled_on:
		n_cam.position = Vector2.ZERO
	else:
		n_cam.global_position = n_cam.get_screen_center_position()

func _physics_process(delta: float) -> void:
	if !follow_player:
		n_cam.global_position += Input.get_vector("rv_left", "rv_right", "rv_up", "rv_down") * delta * 1000 / (zoom*2)
	n_cam.zoom = n_cam.zoom.lerp(Vector2(zoom,zoom),0.1)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 4 or event.button_index == 5:
			zoom = clampf(zoom + -(event.button_index*2-9)*0.1*(zoom*0.5), 0.25,5)


func _on_f_back_pressed() -> void:
	i = wrapi(i-1, 0, replay_length)
	update()

func _on_f_forw_pressed() -> void:
	i = wrapi(i+1, 0, replay_length)
	update()

func _on_speedup_pressed() -> void:
	speed_i = clampi(speed_i+1, 0, speeds.size()-1)
	$Timer.wait_time = 0.1/speeds[speed_i]
	c_speedsetting.text = str(speeds[speed_i]) + "x"

func _on_speeddown_pressed() -> void:
	speed_i = clampi(speed_i-1, 0, speeds.size()-1)
	$Timer.wait_time = 0.1/speeds[speed_i]
	if speed_i == 0:
		c_speedsetting.text = "0.1x"
	else:
		c_speedsetting.text = str(speeds[speed_i]) + "x"


func _on_chrimb_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().call_group("christmassiers", "c_activate")
	else:
		get_tree().call_group("christmassiers", "c_deactivate")
