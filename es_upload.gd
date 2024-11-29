extends PanelContainer

var filepath

@onready var name_le = $MarginContainer/VBoxContainer/LineEdit
@onready var s_button = $MarginContainer/VBoxContainer/Button

var regex
var caret_le
var caret_word

func _ready() -> void:
	hide()
	regex = RegEx.new()
	regex.compile('([a-zA-Z0-9]+)')

func _on_button_pressed() -> void:
	show()
	
func _on_sbutton_pressed() -> void:
		if name_le.text == "":
			s_button.text = "missing name"
		else:
			gv.nethand.upload_replayfile(name_le.text)
			queue_free()

func _on_dbutton_pressed() -> void:
	$FileDialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	filepath = path

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_BACKSPACE):
		name_le.delete_char_at_caret()
		
	if Input.is_key_pressed(KEY_ENTER):
		_on_sbutton_pressed()

func _on_line_edit_text_changed(new_text: String) -> void:
	caret_le = name_le.caret_column

	caret_word = ""
	for i in regex.search_all(new_text):
		caret_word += i.get_string()
	
	name_le.text = caret_word
	name_le.caret_column = caret_le
