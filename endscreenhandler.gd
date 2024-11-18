extends Node2D

var cam_active = false # free spaghet
var count_active = false
var count_progress : float = 0
var awards : PackedStringArray = ["a free car (1991 toyota corolla)", "a trip to kabul disneyland", "free tuition at pyongyang university", "cancer", ""]

@onready var timelabel = $Sprite2D/Control/MarginContainer/VBoxContainer/VBoxContainer/timelabel
@onready var shotslabel = $Sprite2D/Control/MarginContainer/VBoxContainer/VBoxContainer2/shotslabel
@onready var wplabel = $Sprite2D/Control/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/wplabel
@onready var vistalabel = $Sprite2D/Control/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/vistalabel
@onready var spawner = $spawner
@onready var spawntimer = $spawntimer

var es_collider_scene = preload("res://es_collider.tscn")
var es_collider
const es_collider_types = ["ballmer", "vista", "wphone"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	gv.playernode.n_camera.position_smoothing_speed = lerpf(gv.playernode.n_camera.position_smoothing_speed, 50, 0.0005)
	if cam_active:
		if gv.playernode.n_camera.global_position.y > -12223:
			gv.playernode.n_camera.global_position.y = gv.playernode.global_position.y
		elif gv.playernode.n_camera.global_position.y < -12223:
			gv.playernode.n_camera.global_position.y = -12223
			
	if count_active:
		count_progress = clampf(remap(global_position.distance_to(gv.playernode.n_camera.get_screen_center_position()), 1000, 1, 0, 1), 0, 1)
		timelabel.text = Time.get_time_string_from_unix_time((count_progress * gtime.value) / 1000)
		shotslabel.text = str(round(count_progress * gv.shots_fired)) + " times"
		wplabel.text = str(round(count_progress * gv.wphones))
		vistalabel.text = str(round(count_progress * gv.vistas))
		gv.playernode.linear_damp = count_progress * 3		
		
		if count_progress >= 1:
			count_progress = 1
			count_active = false
			gv.playernode.gravity_scale = 0
			gv.playernode.linear_damp = 0
			spawntimer.start(10)
			gv.can_fire = true
			$Sprite2D/Control/MarginContainer/VBoxContainer/VBoxContainer4/awardlabel.text = awards[randi_range(0, awards.size()-1)]



func _on_tunnelstart_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gv.playernode.gravity_scale = -0.1
		cam_active = true
		count_active = true
		gv.can_fire = false
		gv.playernode.n_camera.top_level = true
		gv.playernode.n_camera.global_position.x = -5390
		


func _on_tunnelend_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gtime.stop()
		gv.playernode.n_timerlabel.visible = false

	if body.name == "es_collider":
		print("es cleared")
		body.queue_free()


func _on_spawntimer_timeout() -> void:
	if randi_range(0,30) == 30:
		es_collider = preload("res://player.tscn").instantiate()
		es_collider.gravity_scale = 0
	else:
		es_collider = es_collider_scene.instantiate()
		es_collider.type = es_collider_types.pick_random()
	spawner.add_child(es_collider)
	es_collider.apply_central_impulse(Vector2(randf_range(-10,10), -250))
	spawntimer.start(1)
