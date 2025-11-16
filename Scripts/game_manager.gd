extends Node
@onready var navigation_region_3d: NavigationRegion3D = $"../NavigationRegion3D"
var Enemy_count : int = 10
const ENEMIES = preload("uid://lrrrysua6ugb")
@export var player : Cube
var enemy_names = [
	"Crawler",
	"Stalker",
	"Ripper",
	"Shade",
	"Gnawer",
	"Drifter",
	"Spitter",
	"Grunt",
	"Mauler",
	"Striker",
	"Biter",
	"Lurker",
	"Stomper",
	"Ghoul",
	"Brute",
	"Wretch",
	"Hunter",
	"Fang",
	"Screamer",
	"Reaver",
	"Gnasher",
	"Howler",
	"Skitter",
	"Shambler",
	"Piercer",
	"Twitcher",
	"Ravager",
	"Slicer",
	"Doomling",
    "Blinker"
]


func _ready() -> void:
	spaw_all_enemies()


func spaw_all_enemies():
	for i in range(Enemy_count):
		var instance_of_enemy : Cube = ENEMIES.instantiate()
		instance_of_enemy.name = enemy_names[i]
		instance_of_enemy.global_position = Vector3(randi_range(-30,30), 1, randi_range(-30,30))
		instance_of_enemy.died.connect(on_enemy_died)
		navigation_region_3d.add_child(instance_of_enemy)
		#player.write_info(enemy_names[i] + " was spawed")


func on_enemy_died(enemy: Cube, by_who, g_position):
	player.write_info(by_who + " - kileld - " + enemy.name)
	var enemy_name : String = enemy.name
	enemy.queue_free()
	await get_tree().create_timer(randf_range(1,3)).timeout
	var instance_of_enemy : Cube = ENEMIES.instantiate()
	instance_of_enemy.died.connect(on_enemy_died)
	instance_of_enemy.name = enemy_name
	instance_of_enemy.global_position = Vector3(randi_range(-30,30), 1, randi_range(-30,30))
	navigation_region_3d.add_child(instance_of_enemy)
	#player.write_info("Enemy was spawed")
	


func _on_player_died(Name: Cube, Killer_name: String, g_position: Vector3) -> void:
	player.write_info("You was killed by " + Killer_name)
	player.visible = false
	player.set_process(false)
	player.set_physics_process(false)
	await get_tree().create_timer(randf_range(1,3)).timeout
	player.global_position = Vector3(randi_range(-30,30), 1, randi_range(-30,30))
	player.hp = 100
	player.take_damage(0," ")
	player.visible = true
	player.set_process(true)
	player.set_physics_process(true)
	player.inner_Cube_ready()
	#player.write_info("Player has been respawed!")
	
