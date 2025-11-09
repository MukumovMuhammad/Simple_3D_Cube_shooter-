extends  Cube


@onready var ray: RayCast3D = $RayCast3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var target_position : Vector3
@onready var area : Area3D = $Area3D
var is_fighting : bool = false

func _ready() -> void:
	inner_Cube_ready()


func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	for body in area.get_overlapping_bodies():
		if body.is_in_group("Cube"):
			ray.look_at(body.global_position)
			#Here checking the body is in group of Cube for the second time is done 
			#so as to be sure the ray castos seeing it properly
			if ray.is_colliding() and ray.get_collider().is_in_group("Cube"):
				is_fighting = true
				target_position = body.global_position
			else:
				is_fighting = false
		
	nav_agent.set_target_position(target_position)
	var next_point = nav_agent.get_next_path_position()
	velocity = (next_point- global_transform.origin).normalized() * speed
	
	

	if global_position.distance_to(nav_agent.get_final_position()) <= 2:
		target_position = Vector3(randi_range(-30,30), 1, randi_range(-30,30))
	
	
	look_at(Vector3(target_position.x, global_position.y, target_position.z), Vector3.UP)
	
	if is_fighting:
		velocity = Vector3.ZERO
		
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Cube"):
		print_debug("The Cube entered the area")
		ray.look_at(body.position)
		
			
			
