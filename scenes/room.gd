extends Node3D

signal start

var spot_lights
var robot
var camera

var a = true

var states = ["spotlights","camera_slowsdown","transition","lookat"]
var current_state = ""

func _ready():
	spot_lights = $Lights
	robot = $"../Control/SubViewportContainer/SubViewport/Robot"
	camera = $"../Camera3D"

	await start
	current_state = "spotlights"
	spot_lights_switch()
	camera_rotation()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			start.emit()

func spot_lights_switch():
	for light in spot_lights.get_children():
		await get_tree().create_timer(1.0).timeout
		light.visible=!light.visible
	current_state = "camera_slowsdown"


func camera_rotation():
	while current_state=="spotlights":
		camera.camera_pivot_rotation.y -= 0.55
		camera.set_cam_position(camera.camera_pivot, camera.camera_pivot_rotation, camera.camera_distance)
		await get_tree().process_frame
		
	var t = 0.0
	while current_state=="camera_slowsdown":
		t += get_process_delta_time() * 0.25
		camera.camera_pivot_rotation.y -= (1-t)*0.55
		camera.set_cam_position(camera.camera_pivot, camera.camera_pivot_rotation, camera.camera_distance)
		
		if t >= 1.0:
			current_state="transition"
		await get_tree().process_frame
		
		
	t = 0.0
	var pos = camera.position
	var rot = camera.rotation
	while current_state=="transition":
		t += get_process_delta_time() * 0.5
		#camera.position = pos.lerp(Vector3(0.0,1.5,0.0), t)
		var handles = [0.0,1.0,1.0,1.0] # https://cubic-bezier.com/#0,0,1,1
		var pre_a = Vector3(0.0,0.0,0.0)
		var post_b = Vector3(0.0,0.0,0.0)
		camera.position = pos.cubic_interpolate(Vector3(0.0,1.5,0.0),pre_a,post_b, t)
		
		var tr = Node3D.new()
		tr.look_at_from_position(camera.position,robot.get_children()[1].global_position)
		camera.rotation = rot.lerp(tr.rotation, t)
		if t>1.0:
			current_state = "lookat"
		await get_tree().process_frame
