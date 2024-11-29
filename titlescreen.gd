extends Node2D

var title_extensions : PackedStringArray = PackedStringArray(["Deluxe","Limited Edition","Premium Edition","Remastered","Digital Edition","PS2 Bundle","+ 2 Months Satellaview","+ 1 Months PornHub Premium","Only on Nintendo Virtual Boy","Nintendo Switch 7 Bundle Edition","Free Collectible Steve Ballmer Figurine included!","As Seen on TV Edition","With Pre-Order Bonus","2013 Remake","Pre-Code Version","With 50 Graphics!","Denuvo Edition!","IStGHJ approved Release"])
var filepath
var file
var line

func _ready() -> void:
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
