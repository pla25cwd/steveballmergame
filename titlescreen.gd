extends Node2D

var title_extensions : PackedStringArray = PackedStringArray()
var filepath
var file
var line

func _ready() -> void:
	
	$complaint.visible = false
	$complaint2.visible = false
	
	if OS.has_feature("editor"):
		filepath = "/home/saddam/new-game-project/external/mbs_titles"
	else:
		filepath = OS.get_executable_path().get_base_dir().path_join("mbs_titles")
		
	if FileAccess.file_exists(filepath):
		file = FileAccess.open(filepath, FileAccess.READ)
		while !file.eof_reached():
			title_extensions.append(file.get_line())
		
	else:
		$complaint.visible = true
	
	for i in randi_range(3,mini(10,title_extensions.size())):
		line = randi_range(0,title_extensions.size()-1)
		$versionn3.text += title_extensions[line] + " "
		title_extensions.remove_at(line)
	
func audiohandler_disabled():
	$complaint2.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		gv.playernode.exit_spawn()
		$Area2D.queue_free()

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gv.can_fire = true
		gv.playernode.get_child(1).visible = true
		$Area2D2.queue_free()
		$AudioStreamPlayer.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gv.can_fire = false
		gv.playernode.get_child(1).visible = false
		gv.playernode.find_child("Camera2D").limit_bottom = 900
		gv.playernode.cam_zoom_override = 0.9
