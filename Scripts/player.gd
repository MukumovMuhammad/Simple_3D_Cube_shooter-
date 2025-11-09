extends Cube



@onready var camera_mount: Node3D = $Camera_mount
@onready var Camera: Camera3D = $Camera_mount/Camera3D
@onready var weapon: Node3D = $hands
@onready var weapon_point : Marker3D = $hands/Weapon/Marker3D
@onready var ray_cast: RayCast3D = $Camera_mount/Camera3D/RayCast3D


#fov
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5
var lerp_speed := 3.0



var sens_horizontal = 0.5
var sens_vertical = 0.5

func _ready() -> void:
	speed = 7.0
	jumo_velocity = 7.5
	inner_Cube_ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal)) 
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		weapon.rotation.x = camera_mount.rotation.x
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		print_debug("Player Jumpt")
		velocity.y = jumo_velocity
	
	
	if Input.is_action_pressed("fire"):
		shoot(weapon_point)

	# Get the input direction and handle the movement/deceleration.	
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "fd", "bk")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	#camera FOV
	var velocity_clambed = clamp(velocity.length(), 0.5, speed * 4)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clambed
	Camera.fov = lerp(Camera.fov, target_fov, lerp_speed * delta)
	move_and_slide()
