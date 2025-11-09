extends  CharacterBody3D

const ENEMIES = preload("res://enemies.tres")
var hp = 10
@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D

func _ready() -> void:
	mesh_instance_3d.mesh = mesh_instance_3d.mesh.duplicate()
	var new_material = ENEMIES.duplicate()
	mesh_instance_3d.mesh.material = new_material
	mesh_instance_3d.mesh.material.albedo_color = Color(0, 0, 0)

func hit():
	var the_color: Color = mesh_instance_3d.mesh.material.albedo_color 
	mesh_instance_3d.mesh.material.albedo_color += Color(0.1, 0, 0)
	hp-=1
	
	
	if hp < 1:
		queue_free()
	await get_tree().create_timer(0.5)
	
