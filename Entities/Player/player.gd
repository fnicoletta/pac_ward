class_name Player
extends CharacterBody3D

@export var mouse_sensitivity: float = 0.006
@export_group("Speed")
@export var walk_speed: float = 3
@export var run_speed: float = 7
@export var crouch_speed: float = 1.5

@onready var camera: Camera3D = %Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		_handle_camera_input(event.relative)


func _physics_process(delta: float) -> void:
	var current_speed = _handle_choose_speed()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()


func _handle_choose_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return run_speed
	if Input.is_action_pressed("crouch"):
		return crouch_speed
	return walk_speed


func _handle_camera_input(mouse_motion: Vector2):
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	
	rotate_y(-mouse_motion.x * mouse_sensitivity)
		
	camera.rotate_x(-mouse_motion.y * mouse_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
