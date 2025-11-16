extends CharacterBody3D
class_name Cube

signal died(Name, Killer_name, g_position)


var is_dead : bool = false
var hp := 100
@export var Cube_health_label: Label3D
@export var speed := 5.0
var jumo_velocity := 5.0

@onready var bullet_scene = load("res://Scenes/bullets.tscn")
@export var mesh: MeshInstance3D
var shoot_cooldown : float = 0.4
@onready var can_shoot : bool = true

func inner_Cube_ready() -> void:
	# Each cube gets its own material copy
	is_dead = false
	mesh.set_surface_override_material(0, mesh.get_active_material(0).duplicate())
	if Cube_health_label:
		Cube_health_label.text = str(hp)
		Cube_health_label.modulate = Color(1-hp/100, hp/100, 0)


func shoot(bullet_pos: Marker3D):
	if can_shoot:
		can_shoot = false
		var instance_of_bullet = bullet_scene.instantiate()
		instance_of_bullet.shoot_by_who = name
		instance_of_bullet.position = bullet_pos.position
		instance_of_bullet.global_position = bullet_pos.global_position
		instance_of_bullet.transform.basis = bullet_pos.global_transform.basis
		get_parent().add_child(instance_of_bullet)
		
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true



func take_damage(amount: int, who: String) -> void:
	if is_dead:
		return
	hp -= amount
	if Cube_health_label:
		Cube_health_label.text = str(hp)
		Cube_health_label.modulate = Color(1-hp/100, hp/100, 0)
	if hp <= 0:
		die(who)
	else:
		var mat := mesh.get_active_material(0)
		mat.albedo_color += Color(0.1, 0, 0)

func die(who: String) -> void:
	is_dead = true
	emit_signal("died", self, who, global_position)
