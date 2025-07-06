extends Node

var wphones : int = 0
var vistas : int = 0
var can_fire = true
var nh_open = false
var shots_fired : int = 0

var playernode : Node2D
var audiohandler : Node
var nethand : CanvasLayer

func _init() -> void:
	pass
#	JavaScriptBridge.get_interface("document").getElementById("splash").remove()

func decode_float32arr(float32arr : float):
	var tmp_value : Array[bool] = []
	var mod = float32arr
	var prev_mod = float32arr
	for i in 32:
		mod = fmod(mod, pow(2,31-i))
		tmp_value.append(!mod == prev_mod)
		prev_mod = mod
	tmp_value.reverse()
	return tmp_value
	
func encode_float32arr(arr : Array[bool]):
	var tmp_value : int = 0
	if arr.size() > 32:
		return
	for i in arr.size():
		tmp_value += pow(2, i)*int(arr[i])
	return tmp_value
