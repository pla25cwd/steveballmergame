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

@export var ballmer_on_crack : bool = false
@export var substance_steady : float = 0.95
@onready var substance_anim : AnimationPlayer = $substance

func _physics_process(delta: float) -> void:
	
	n_rotation.rotation += lerpf(n_rotation.get_angle_to(get_global_mouse_position()), 0, substance_steady)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and n_timer.time_left == 0:
		fire()
	
	if cam_zoom_override == 0:
		cam_zoom_target = remap(linear_velocity.length(), 0.0, 1000.0, 1.75, 0.25)
	else:
		cam_zoom_target = cam_zoom_override
	
	cam_zoom_current = lerpf(cam_zoom_current, cam_zoom_target, 0.01)
	n_camera.zoom = Vector2(cam_zoom_current, cam_zoom_current)
	n_timerlabel.text = Time.get_time_string_from_unix_time(Time.get_ticks_msec() / 1000)
	if ballmer_on_crack:
		n_sprite.offset = Vector2(randf_range(-1,1),randf_range(-1,1))

func fire() -> void:
	apply_central_impulse((n_vec.global_position - global_position)*75)
	apply_impulse(Vector2(-1,0), (n_vecpos.global_position - global_position)*100) # ???????????
	n_flash.skew = randf_range(-25,25)
	n_flash.rotation_degrees = randf_range(-10,10)
	n_flash.frame = randi_range(0,1)
	if b2loaded or ballmer_on_crack:
		n_flashanim.play("b2")
		n_timer.start(0.5)
		b2loaded = false
	else:
		n_flashanim.play("new_animation")
		n_timer.start(2)
		b2loaded = true

func substance_pickup():
	substance_anim.play("new_animation")
