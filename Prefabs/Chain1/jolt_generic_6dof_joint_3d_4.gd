extends JoltGeneric6DOFJoint3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("correct:",self.get_param_y(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_LIMIT_LOWER))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
