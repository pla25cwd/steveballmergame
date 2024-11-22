extends PanelContainer

var filepath

@onready var fp_label = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/HBoxContainer/Label
@onready var net_panel = $MarginContainer/VBoxContainer/HBoxContainer2/PanelContainer/Panel
@onready var file_panel = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/Panel
@onready var name_le = $MarginContainer/VBoxContainer/HBoxContainer2/PanelContainer/LineEdit
@onready var file_button = $MarginContainer/VBoxContainer/HBoxContainer/CheckButton
@onready var net_button = $MarginContainer/VBoxContainer/HBoxContainer2/CheckButton
@onready var s_button = $MarginContainer/VBoxContainer/Button

var regex
var caret_le
var caret_word

func _ready() -> void:
	hide()
	regex = RegEx.new()
	regex.compile('([a-z]|[A-Z])')

func _on_button_pressed() -> void:
	show()
	
func _on_sbutton_pressed() -> void:
	if file_button.button_pressed or net_button.button_pressed:
		if name_le.text == "" and net_button.button_pressed:
			s_button.text = "missing name"
			return
		
		if filepath == "" and file_button.button_pressed:
			s_button.text == "missing filepath"
			return
		
		if file_button.button_pressed:
			gv.nethand.save_replayfile(filepath)
		
		if net_button.button_pressed:
			gv.nethand.upload_replayfile(name_le.text)
		
		queue_free()
		
	else:
		hide()
	
func _on_check_button_toggled(toggled_on: bool) -> void:
	file_panel.visible = !toggled_on
	update_s_button()

func _on_dbutton_pressed() -> void:
	$FileDialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	filepath = path
	fp_label.text = path


func _on_n_check_button_toggled(toggled_on: bool) -> void:
	net_panel.visible = !toggled_on
	update_s_button()

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_BACKSPACE):
		name_le.delete_char_at_caret()
		
	if Input.is_key_pressed(KEY_ENTER):
		_on_sbutton_pressed()

func update_s_button():
	if net_button.button_pressed and file_button.button_pressed:
		s_button.text = "upload and save"
	elif net_button.button_pressed and !file_button.button_pressed:
		s_button.text = "upload"
	elif !net_button.button_pressed and file_button.button_pressed:
		s_button.text = "save"
	elif !net_button.button_pressed and !file_button.button_pressed:
		s_button.text = "do literally nothing"


func _on_line_edit_text_changed(new_text: String) -> void:
	caret_le = name_le.caret_column

	caret_word = ""
	for i in regex.search_all(new_text):
		caret_word += i.get_string()
	
	name_le.text = caret_word
	name_le.caret_column = caret_le
