extends Node2D

@export var homing : bool
@export var frame : int
var active : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var timer : Timer = $Timer
@onready var ray : RayCast2D = $RayCast2D
@onready var explosion : Sprite2D = $Sprite2D2

func _ready() -> void:
	sprite.visible = false
	explosion.visible = false
	
	activate()

func activate():
	sprite.frame_coords = Vector2(frame, homing)
	sprite.visible = true
	active = true
	look_at(gv.playernode.global_position)
	
func explode():
	active = false
	timer.start()
	explosion.rotate(randf())
	explosion.visible = true
	sprite.visible = false

func _physics_process(delta: float) -> void:
	if active:
		if homing:
			rotate(lerpf(0, get_angle_to(gv.playernode.global_position)+randf_range(-2,2), 0.05))
		else:
			sprite.rotation_degrees += 5
	
		if ray.is_colliding():
			if ray.get_collider().name == "player":
				gv.playernode.apply_central_impulse(gv.playernode.global_position.direction_to(global_position) * -500)
				explode()
			elif ray.get_collider().name != "tuxler":
				explode()
		
		move_local_x(2, true)

func _on_timer_timeout() -> void:
	queue_free()
