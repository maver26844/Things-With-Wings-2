extends CharacterBody3D

@export var spd = 15.0
@export var jumpVelocity = 7
@export var sensitivity = 700

#@onready var Camera = $CameraPivot/Camera

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Armature_001|float")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_pressed("flap") and not $AnimationPlayer.get_current_animation() == "Armature_001|flap":
		velocity.y = jumpVelocity
		$AnimationPlayer.play("Armature_001|flap")
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("right", "left", "backward", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() # normalized makes diagonal movement not faster
	if direction:
		velocity.x = direction.x * spd
		velocity.z = direction.z * spd
	else:
		velocity.x = move_toward(velocity.x, 0, spd)
		velocity.z = move_toward(velocity.z, 0, spd)
	move_and_slide()

func _input(event):
	if not Input.is_action_pressed("freelook"): # Resets camera y rotation after freelook
			$CameraPivot.rotation.y = 0
	if event is InputEventMouseMotion:
		$CameraPivot.rotation.x -= event.relative.y / sensitivity
		if Input.is_action_pressed("freelook"):
			$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			$CameraPivot.rotation.y -= event.relative.x / sensitivity
		else:
			$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			rotation.y -= event.relative.x / sensitivity
