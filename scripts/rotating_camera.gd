extends Camera3D


# https://stackoverflow.com/questions/76893256/how-to-get-the-3d-mouse-pos-in-godot-4-1

var left_mouse_position
var right_mouse_dragging
var middle_mouse_dragging

var first_3d_position
var current_3d_mouse_position

var camera_active
var camera_pivot
var camera_pivot_rotation

var camera_distance
var camera_distance_min
var camera_distance_max
var camera_zoom_speed
var camera_rotating_speed
var camera_drag_speed
var camera_drag_speed_k

var viewport_size

var pivot_obj
var pointer_obj

@export_category("Default Settings")

@export var start_camera_pivot : Vector3 = Vector3(0.0,0.0,0.0) ## The position that camera will look at (its pivot point)
@export var start_camera_pivot_rotation : Vector3 = Vector3(-45,45,0.0) ## The rotation that camera will be rotated around pivot (degrees)
@export var start_camera_distance : float = 10 ## The zoom/distance camera will be from pivot
@export var camera_rotation_speed : float = 0.1 ## The speed camera rotates around pivot

func _ready():
	viewport_size = get_viewport().size

	camera_pivot = start_camera_pivot
	camera_pivot_rotation = start_camera_pivot_rotation
	
	camera_distance = start_camera_distance
	
	set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
		
	
func _process(_delta):
	camera_pivot_rotation.y += camera_rotation_speed
	camera_pivot_rotation.x = clamp(camera_pivot_rotation.x, -80, 80)
	set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
		
func set_cam_position(pivot, pivot_rotation, distance):
	var rotation_basis = get_basis_from_deg_euler(pivot_rotation)
	#print(type_string(typeof(rotation_basis)))
	global_position = pivot + rotation_basis * Vector3(0,0,distance)
	look_at(pivot)
	
func get_basis_from_deg_euler(deg_rotation):
	var rad_rotation = Vector3(deg_to_rad(deg_rotation.x),deg_to_rad(deg_rotation.y),deg_to_rad(deg_rotation.z))
	var rotation_basis = Basis.from_euler(rad_rotation)
	return rotation_basis

		
