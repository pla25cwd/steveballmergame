extends Node

var filepath : String
var file : String
var mapping : Array
var mapping_size : int
var selection_i
var current : int
var previous : PackedInt32Array = PackedInt32Array()

var audioplayer : AudioStreamPlayer
var subtitlelabel : Label

var db_selectiontime : float

func _ready() -> void:
	if OS.has_feature("editor"):
		filepath = "/home/saddam/new-game-project/external/quotes/"
	else:
		filepath = OS.get_executable_path().get_base_dir().path_join("quotes/")

	if !FileAccess.file_exists(filepath.path_join("mapping.json")):
		get_tree().call_group("audiohandler_affected", "audiohandler_disabled")
		queue_free()
	
	file = FileAccess.get_file_as_string(filepath.path_join("mapping.json"))
	mapping = JSON.parse_string(file)

	audioplayer = $asshole
	subtitlelabel = gv.playernode.get_node("CanvasLayer2/Control/subtitle")
	gv.audiohandler = self

func play_random():
	if audioplayer.playing:
		print("already playing")
		return
	mapping_size = mapping.size()-1
	current = randi_range(0, mapping_size)
	db_selectiontime = Time.get_ticks_msec()
	selection_i = 0
	while previous.has(current):
		selection_i += 1
		if selection_i > 10:
			previous = previous.slice(previous.size()-11, previous.size()-1)
			
		print(str(Time.get_ticks_msec()) + ": previous contains random selection")
		current = randi_range(0, mapping_size)
	
	db_selectiontime = (Time.get_ticks_msec() - db_selectiontime)
	print("selection took " + str(db_selectiontime))
	print(str(previous))
	previous.append(current)
	
	
	subtitlelabel.text = mapping[current]["subtitle"]
	audioplayer.stream = AudioStreamOggVorbis.load_from_file(filepath.path_join(mapping[current]["path"]))
	print(str(filepath.path_join(mapping[current]["path"])))
	audioplayer.play()

func _on_asshole_finished() -> void:
	subtitlelabel.text = ""
