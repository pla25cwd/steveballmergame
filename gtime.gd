extends Node

var value = 0
var offset = 0
var active : bool = false


func _physics_process(delta: float) -> void:
	if active:
		value = Time.get_ticks_msec() - offset
		
func start():
	active = true
	offset = Time.get_ticks_msec()
	
func stop():
	active = false
