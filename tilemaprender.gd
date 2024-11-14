extends Node2D

@export_category("Setup")
@export var tilemap : TileMapLayer
@export var camera : Camera2D
@export_global_dir var save_location : String

func _ready() -> void:	
	var viewport_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var viewport_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	var viewport_xy_vec = Vector2(viewport_x, viewport_y) # convenient i guess
	
	var tb = tilemap.get_used_rect()
	
	var tb_local = tilemap.map_to_local(tb.position)
	var cpm_origin = Vector2i.ZERO
	cpm_origin = tb_local.snapped(viewport_xy_vec)
	
	var tb_size = tilemap.map_to_local(tb.size).snapped(viewport_xy_vec) + viewport_xy_vec
	var cpm_steps = tb_size / viewport_xy_vec
	
	camera.position = cpm_origin
	for y in cpm_steps.y:
		camera.position.y = cpm_origin.y + (y * viewport_y) # i dont even know man
		for x in cpm_steps.x:
			camera.position.x = cpm_origin.x + (x * viewport_x)
			print("waiting " + str(Time.get_ticks_msec()))
			await RenderingServer.frame_post_draw
			print("done waiting " + str(Time.get_ticks_msec()))
			camera.get_viewport().get_texture().get_image().save_png(save_location + "/render_" + str(y) + "c" + str(x) + ".png")
			# format string? what the fuck is that?
			
	print("steps x: " + str(cpm_steps.x) + " steps y: " + str(cpm_steps.y))

	
