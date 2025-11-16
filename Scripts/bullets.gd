extends Node3D
@onready var mesh = $MeshInstance3D
@onready var particles = $CPUParticles3D
var velocity = Vector3.ZERO
@onready var ray = $RayCast3D
const SPEED = 40.0
var shoot_by_who : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#translate(get_transform().basis.z.normalized() * delta * SPEED)
	#var dir = (global_basis * Vector3(0,0,-1)).normalized()
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		if ray.get_collider().is_in_group("Cube"):
			ray.get_collider().take_damage(10,shoot_by_who)
		await  get_tree().create_timer(1.0).timeout
		queue_free()


func set_velocity(target):
	print_debug("The velocity of the bullet is set to ", target, "\nMy rotation: ", rotation_degrees)
	look_at(target)
	print("Rotation after looking at target : ", rotation_degrees)
	velocity = global_position.direction_to(target) * SPEED

func _on_timer_timeout():
	queue_free()
