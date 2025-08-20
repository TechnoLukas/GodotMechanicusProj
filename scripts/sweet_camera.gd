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

@export_enum("tab_switch","always_active","always_deactive") var camera_mode = 0
@export var start_camera_pivot : Vector3 = Vector3(0.0,0.0,0.0) ## The position that camera will look at (its pivot point)
@export var start_camera_pivot_rotation : Vector3 = Vector3(-45,45,0.0) ## The rotation that camera will be rotated around pivot (degreees)
@export var start_camera_distance : float = 10 ## The zoom/distance camera will be from pivot

@export_category("Features")
@export var do_draging : bool = true
@export var do_rotating : bool = true
@export var do_zooming : bool = true
@export var do_grabbing : bool = true

@export_category("Miscellaneous")
@export var show_elements : bool = true ## If true, will show the pivot points and red cursor
@export var use_warning : bool = true ## If true, it will warn you if you accedentally drag on invisible object.

func _ready():
	viewport_size = get_viewport().size
	
	left_mouse_position = null
	right_mouse_dragging = false
	middle_mouse_dragging = false

	first_3d_position = []
	current_3d_mouse_position = null
	
	camera_active = camera_mode == 1
	camera_pivot = start_camera_pivot
	camera_pivot_rotation = start_camera_pivot_rotation
	
	camera_distance = start_camera_distance
	camera_distance_min = 0.5
	camera_distance_max = 35.0
	camera_zoom_speed = 0.1
	camera_rotating_speed = Vector2(viewport_size.x/(360*20.0),viewport_size.y/(180*20.0))
	camera_drag_speed = 0.005
	camera_drag_speed_k = 1000
	
	# Visuals:
	pivot_obj = CSGSphere3D.new()
	pointer_obj = CSGSphere3D.new()
	var pivot_obj_material = StandardMaterial3D.new()
	var pointer_obj_material = StandardMaterial3D.new()
	pivot_obj.radius = 0.05
	pointer_obj.radius = 0.05
	pivot_obj_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	pivot_obj_material.albedo_color = Color(0.416,0.416,0.416,0.314)
	pointer_obj_material.albedo_color = Color(1.0,0.0,0.0)
	pivot_obj.material = pivot_obj_material
	pointer_obj.material = pointer_obj_material
	pointer_obj.position = camera_pivot
	
	
	pivot_obj.visible = show_elements
	
	get_tree().root.add_child.call_deferred(pivot_obj)
	get_tree().root.add_child.call_deferred(pointer_obj)
	
	set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		if camera_mode == 0: # tab_switch
			camera_active =! camera_active
		elif camera_mode == 1: # always_active
			camera_active = true
		elif camera_mode == 2: # always_deactive
			camera_active = false
		
		
		pivot_obj.visible = camera_active and show_elements
			
	
	if event is InputEventMouseButton and camera_active:
		if event.button_index == MOUSE_BUTTON_LEFT and do_grabbing:
			if event.pressed:
				left_mouse_position = event.position
			else:
				left_mouse_position = null
				first_3d_position = []
				
		if event.button_index == MOUSE_BUTTON_RIGHT and do_rotating:
			right_mouse_dragging = event.pressed
		if event.button_index == MOUSE_BUTTON_MIDDLE and do_draging:
			middle_mouse_dragging = event.pressed
				
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and do_zooming:
			if camera_distance > camera_distance_min:
				camera_distance -= camera_zoom_speed * camera_distance/2.5
				camera_drag_speed = camera_distance / camera_drag_speed_k
				set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and do_zooming:
			if camera_distance < camera_distance_max:
				camera_distance += camera_zoom_speed * camera_distance/2.5
				camera_drag_speed = camera_distance / camera_drag_speed_k
				set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
				
				
	if event is InputEventMouseMotion:
		if left_mouse_position!=null:
			left_mouse_position = event.position
		
		if right_mouse_dragging:
			camera_pivot_rotation.y += -event.relative.x*camera_rotating_speed.x
			camera_pivot_rotation.x += -event.relative.y*camera_rotating_speed.y
			camera_pivot_rotation.x = clamp(camera_pivot_rotation.x, -80, 80)
			set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
			
		if middle_mouse_dragging:

			#var pos = (get_viewport().get_mouse_position()-viewport_size*0.5)/500
			#$"../pointer3".position = transform.basis * Vector3(pos.x,-pos.y,2.5)
			
			var pos = event.relative*camera_drag_speed
			camera_pivot += transform.basis * Vector3(-pos.x,pos.y,0)
			set_cam_position(camera_pivot, camera_pivot_rotation, camera_distance)
			pivot_obj.position = camera_pivot
			
			
			
			


		
	

func calculate_3d_ray(mouse_position, dist):
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		var direction = camera.project_ray_normal(mouse_position)
		var end = origin + direction * dist
		
		if dist != far: 
			var n = Node3D.new()
			n.position = end
			return n

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		var ray = space_state.intersect_ray(query)
		return ray
		
	

func _physics_process(_delta):
	if left_mouse_position != null and camera_active:
		var ray
		if first_3d_position == []:
			ray = calculate_3d_ray(left_mouse_position, far)
			if ray == {}: return
			first_3d_position=[ray.collider, ray.position, (ray.position-ray.collider.global_position) * ray.collider.global_transform.basis]
			#print(first_3d_position)
		else:
			ray = calculate_3d_ray(left_mouse_position, self.position.distance_to(first_3d_position[1]))
		
		current_3d_mouse_position = ray.position
		
		if first_3d_position[0] is RigidBody3D:
			var diff_vec = current_3d_mouse_position - (first_3d_position[0].global_position + first_3d_position[0].global_transform.basis*first_3d_position[2])
			var velocity = first_3d_position[0].linear_velocity
			var spring_strength = 25#50#25.0
			var damping = 1 * sqrt(spring_strength)  # critical damping
			
			first_3d_position[0].apply_force(diff_vec * spring_strength - velocity * damping, first_3d_position[0].global_transform.basis*first_3d_position[2])
		
		if first_3d_position[0].is_visible_in_tree() == false and use_warning:
			#print("hi")
			push_warning("The coursor is on invisible object: ", first_3d_position[0]) # I accedentaly forgot that i had invis object and spent 30min confused what my code did not work :0
			
func _process(_delta):
	if left_mouse_position != null and camera_active:
		pointer_obj.visible = show_elements
		if first_3d_position != []:
			pointer_obj.position = current_3d_mouse_position
	else:
		pointer_obj.visible = false
		
func set_cam_position(pivot, pivot_rotation, distance):
	var rotation_basis = get_basis_from_deg_euler(pivot_rotation)
	#print(type_string(typeof(rotation_basis)))
	global_position = pivot + rotation_basis * Vector3(0,0,distance)
	look_at(pivot)
	
func get_basis_from_deg_euler(deg_rotation):
	var rad_rotation = Vector3(deg_to_rad(deg_rotation.x),deg_to_rad(deg_rotation.y),deg_to_rad(deg_rotation.z))
	var rotation_basis = Basis.from_euler(rad_rotation)
	return rotation_basis

		
