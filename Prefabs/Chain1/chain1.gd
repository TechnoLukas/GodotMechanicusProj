extends Node3D

@export_enum("pure_collision","joint_no_collision","joint_with_collision") var collision_type
@export_enum("PinJoint3D","Generic6DOFJoint3D") var joint_type
@export var link_num = 10

var link_list = []

func _ready() -> void:
	var scene = load("res://Prefabs/Chain1/link1.tscn")
	
	var link = scene.instantiate()
	link.rotation_degrees = Vector3(0.0,0.0,-90.0)
	#add_child(link)

	while link_list.size() < link_num:
		var count = link_list.size()
		var new_link: RigidBody3D = link.duplicate()
		new_link.position.y -= 0.6*count
		new_link.rotation_degrees.y += 90*(count%2)
		new_link.freeze = true
		add_child(new_link)
		link_list.append(new_link)	


	if collision_type == 1 or collision_type == 2:
		for link_idx in range(1,link_list.size()):
			#print("link", link_idx-1,"<>",link_idx)
			
			var link_joint
			if joint_type == 0:
				link_joint = PinJoint3D.new() #JoltGeneric6DOFJoint3D #JoltPinJoint3D
			elif joint_type == 1:
				link_joint = Generic6DOFJoint3D.new()
				link_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT,false)
				link_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT,false)
				link_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT,true)
				link_joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, deg_to_rad(25.0))
				link_joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, deg_to_rad(-25.0))

				link_joint.position.y -= 0.6*link_idx - 0.175
				link_joint.node_a = link_list[link_idx-1].get_path()
				link_joint.node_b = link_list[link_idx].get_path()
				
				
			if collision_type == 1:
				link_joint.exclude_nodes_from_collision = true
			elif collision_type == 2:
				link_joint.exclude_nodes_from_collision = false
			add_child(link_joint)
		
		
	for my_link in link_list:
		my_link.freeze = false	
			
