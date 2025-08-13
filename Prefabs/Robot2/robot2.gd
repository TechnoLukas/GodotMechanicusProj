extends Node3D

# Rotation speed in radians per second
@onready var fr_r_wheel: HingeJoint3D = $Fr_R_axies
@onready var fr_l_wheel: HingeJoint3D = $Fr_L_axies
@onready var re_r_wheel: HingeJoint3D = $Re_R_axies
@onready var re_l_wheel: HingeJoint3D = $Re_L_axies
var wheel_rotation_speed = 3


func _physics_process(_delta):
	
	# Arrow keys: rotate around X axis (up/down)
	if Input.is_key_pressed(KEY_E):
		fr_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
		re_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
	elif Input.is_key_pressed(KEY_D):
		fr_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
		re_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
	else:
		fr_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
		re_r_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
	
	
	if Input.is_key_pressed(KEY_W):
		fr_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
		re_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, wheel_rotation_speed)
	elif Input.is_key_pressed(KEY_S):
		fr_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
		re_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -wheel_rotation_speed)
	else:
		fr_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
		re_l_wheel.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0)
