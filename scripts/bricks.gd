extends Node3D

var ran = 0.5

func _ready() -> void:
	var brick = get_child(0)
	for i in range(20):
		var new_brick: Node3D = brick.duplicate()
		#new_brick.rotate(Vector3(randi_range(0,1),randi_range(0,1),randi_range(0,1)).normalized(), deg_to_rad(randf_range(0.0,180.0)))
		new_brick.rotation_degrees += Vector3(randf_range(-180,180),randf_range(-180,180),randf_range(-180,180))
		
		new_brick.position += Vector3(randf_range(-ran,ran),randf_range(-ran,ran),randf_range(-ran,ran)).normalized()
		add_child(new_brick)
	
func _process(_delta: float) -> void:
	pass
