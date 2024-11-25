extends Node

var wphones : int = 69
var vistas : int = 69
var can_fire = true
var nh_open = false
var shots_fired : int = 0

var playernode : Node2D
var audiohandler : Node
var nethand : CanvasLayer

func init_replayviewer():
	get_tree().change_scene_to_packed(preload("res://replayviewer.tscn"))
