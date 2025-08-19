extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at($"../Body".global_position)
	global_position = (Vector3(0.0,1.3,1.84) * $"../Body".global_transform.basis.inverse()) + $"../Body".global_position
