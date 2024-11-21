extends Node2D

@onready var env_anim : AnimationPlayer = $env_anim
@onready var tux_anim : AnimationPlayer = $tux_anim
@onready var atk_timer : Timer = $atk
@onready var atk_spawn_timer : Timer = $atk_spawn
@onready var sprite = $tuxler/Sprite2D

@export var stage = 0
@export var can_atk : bool = false
var spawn_frame
var spawn_i
var spawn_amount
var spawn_homing
var spawn_tmp_node

const atk_anims : Array = ["atk","atk_2","atk_3"]

func _on_arena_body_entered(body: Node2D) -> void:
	if body.name == "player" and !gv.playernode.tuxbattle:
		$tux_anim.play("enter")
		gv.playernode.tuxbattle = true
		gv.playernode.n_camera.top_level = true
		gv.playernode.cam_zoom_override = 0.75
		gv.playernode.n_camera.global_position = global_position
		gv.playernode.n_camera.position_smoothing_speed = 0.5
		
func _on_arena_body_exited(body: Node2D) -> void:
	if body.name == "player":
		gv.playernode.n_camera.position_smoothing_speed = 0.1
		gv.playernode.n_camera.top_level = false
		gv.playernode.cam_zoom_override = 1
		gv.playernode.n_camera.position = Vector2.ZERO

func _on_atk_timeout() -> void:
	if can_atk:
		spawn_frame = randi_range(0,1)
		spawn_amount = randi_range(1,3) + stage
		sprite.frame = 1
		spawn_i = 0
		if stage == 1:
			spawn_homing = bool(randi_range(0,1))
		else:
			spawn_homing = false
		atk_spawn_timer.stop()
		atk_spawn_timer.start(1)

func _on_atk_spawn_timeout() -> void:
	if !can_atk:
		return
	if spawn_i == 0:
		$fire.play()

	if spawn_i < spawn_amount:
		spawn_i += 1
		spawn_tmp_node = preload("res://finaltux/tb_bullet.tscn").instantiate()
		spawn_tmp_node.frame = spawn_frame
		spawn_tmp_node.homing = spawn_homing
		add_child(spawn_tmp_node)
		spawn_tmp_node.position = Vector2(0, 200)
		spawn_tmp_node.activate()
		spawn_tmp_node.rotation_degrees += randf_range(1,2)-stage
		atk_spawn_timer.start(0.3)
	elif spawn_i == spawn_amount:
		spawn_i += 1
		atk_spawn_timer.start(1)
	elif spawn_i == spawn_amount + 1:
		if stage == 0:
			sprite.frame = 0
		match spawn_amount:
			1:
				atk_timer.start(randf_range(1,2))
			2:
				atk_timer.start(randf_range(3,4)-(stage*2))
			3:
				atk_timer.start(randf_range(4,5)-(stage*2))
			4:
				atk_timer.start(randf_range(4,5)-(stage*2))

func _on_button_body_entered(body: Node2D) -> void:
	if body.name == "player":
		env_anim.play("drop_wphones")

func _on_button_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		env_anim.play("drop_vistas")

func change_stage(vstage):
	stage = vstage

func _on_tuxler_coll_body_entered(body: Node2D) -> void:
	if body.name.begins_with("tb_dropobjects"):
		body.die()
		if stage == 0 and !body.vista:
			print("hitwp")
			tux_anim.play("hit_wphones")
		elif stage == 1 and body.vista:
			tux_anim.play("hit_vista")

func c_activate():
	$tuxler/Sprite2D2.visible = true


func _on_ray_cast_2d_body_entered(body: Node2D) -> void:
	$carrier/AnimationPlayer.play("new_animation")
