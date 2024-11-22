extends RigidBody2D

@onready var n_rotation : Node2D = $rotation
@onready var n_vec : Marker2D = $rotation/vec
@onready var n_vecpos : Marker2D = $rotation/Sprite2D/vecpos
@onready var n_timer : Timer = $Timer
@onready var n_camera : Camera2D = $Camera2D
@onready var n_flash : AnimatedSprite2D = $rotation/Sprite2D/vecpos/AnimatedSprite2D
@onready var n_flashanim : AnimationPlayer = $rotation/Sprite2D/vecpos/AnimationPlayer
@onready var n_timerlabel : Label = $CanvasLayer2/Control/timerlabel
@onready var n_sprite : AnimatedSprite2D = $Sprite2D

var cam_zoom_target : float
var cam_zoom_current : float = 1
var cam_zoom_override : float = 0

var b2loaded : bool = true
var tuxbattle : bool = false

var vel_previous = 0
@onready var thud = $thud

@export var ballmer_on_crack : bool = false
@export var aim_steady : float = 0.95
@export var sprite_shake : float = 0
@onready var substance_anim : AnimationPlayer = $substance

var db_save : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if gv.playernode == null:
		gv.playernode = self
	n_timerlabel.visible = false
	gtime.start()

func _physics_process(delta: float) -> void:
	n_rotation.rotation += lerpf(n_rotation.get_angle_to(get_global_mouse_position()), 0, aim_steady)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and n_timer.time_left == 0 and gv.can_fire and !gv.nh_open:
		fire()
	
	if cam_zoom_override == 0:
		cam_zoom_target = remap(linear_velocity.length(), 0.0, 1000.0, 1.25, 0.25)
	else:
		cam_zoom_target = cam_zoom_override

	if (vel_previous-linear_velocity.length()) > 800:
		thud.play()
	vel_previous = linear_velocity.length()

	
	cam_zoom_current = clampf(lerpf(cam_zoom_current, cam_zoom_target, 0.005), 0.25, 1.75)
	n_camera.zoom = Vector2(cam_zoom_current, cam_zoom_current)
	if gtime.active:
		n_timerlabel.text = Time.get_time_string_from_unix_time(gtime.value/ 1000)
		
	if ballmer_on_crack:
		n_sprite.offset = Vector2(randf_range(-sprite_shake,sprite_shake),randf_range(-sprite_shake,sprite_shake))

func fire() -> void:
	apply_central_impulse((n_vec.global_position - global_position)*75)
	apply_impulse(Vector2(-1,0), (n_vecpos.global_position - global_position)*100) # ???????????
	n_flash.skew = randf_range(-25,25)
	n_flash.rotation_degrees = randf_range(-10,10)
	n_flash.frame = randi_range(0,1)
	n_flashanim.stop()
	gv.nethand.replay_fc = true
	if b2loaded or ballmer_on_crack:
		n_flashanim.play("b2")
		n_timer.start(0.5)
		b2loaded = false
		gv.shots_fired += 1
	else:
		n_flashanim.play("new_animation")
		n_timer.start(2)
		b2loaded = true
		gv.shots_fired += 1

func substance_pickup():
	if tuxbattle:
		n_sprite.frame = 1
		gravity_scale = 0.5
		ballmer_on_crack = true
		aim_steady = 0.75
	else:
		substance_anim.play("new_animation")

func exit_spawn():
	gtime.start()
	n_timerlabel.visible = true
	n_camera.limit_bottom = 10000000
	cam_zoom_override = 0

func _input(event: InputEvent) -> void:
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("db1"):
			db_save = position
		if Input.is_action_just_pressed("db2"):
			freeze = true
			set_deferred("position", db_save)
			freeze = false
