extends Node3D

# Rotation speed in radians per second
@onready var r_wheel: HingeJoint3D = $R_axies
@onready var l_wheel: HingeJoint3D = $L_axies
var wheel_rotation_speed = 3


func _physics_process(delta):
	var angular_vel = Vector3.ZERO
	
	# Arrow keys: rotate around X axis (up/down)
	if Input.is_key_pressed(KEY_E):
		r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
	elif Input.is_key_pressed(KEY_D):
		r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
	else:
		r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
	
	
	if Input.is_key_pressed(KEY_W):
		l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
	elif Input.is_key_pressed(KEY_S):
		l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
	else:
		l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
	#if Input.is_action_pressed("ui_down"):
		#angular_vel.x -= wheel_rotation_speed

	# Set the angular velocity
	#r_wheel.angular_velocity = angular_vel
