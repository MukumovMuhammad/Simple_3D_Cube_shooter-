extends Node
@onready var navigation_region_3d: NavigationRegion3D = $"../NavigationRegion3D"
var Enemy_count : int = 9
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

var record_table = [
	#["Name", deaths 3, kills 4]
]

func _ready() -> void:
	record_table.append([player.name, 0,0])
	spaw_all_enemies()
	


func spaw_all_enemies():
	for i in range(Enemy_count):
		var instance_of_enemy : Cube = ENEMIES.instantiate()
		instance_of_enemy.name = enemy_names[i]
		record_table.append([enemy_names[i], 0, 0])
		instance_of_enemy.global_position = Vector3(randi_range(-30,30), 1, randi_range(-30,30))
		instance_of_enemy.died.connect(on_enemy_died)
		navigation_region_3d.add_child(instance_of_enemy)
		#player.write_info(enemy_names[i] + " was spawed")
	player.get_node("CanvasLayer/HUD").add_items_to_table(record_table)


func on_enemy_died(enemy: Cube, by_who, g_position):
	player.write_info(by_who + " - killed - " + enemy.name)
	
	#Updating the death count
	var needed_i = find_index_of_array(record_table, enemy.name)
	record_table[needed_i][1]+=1
	 #+1 so as in items it updated the death 
	player.get_node("CanvasLayer/HUD").modify_item(needed_i, record_table[needed_i][1], 1)
	
	#Updating the Kill count
	needed_i = find_index_of_array(record_table, by_who)
	record_table[needed_i][2]+=1
	 #+2 so as in items it updated the Kills
	player.get_node("CanvasLayer/HUD").modify_item(needed_i, record_table[needed_i][2], 2)
	
	print_debug("The record table is updated!")
	for i in record_table:
		print(" | "+ i[0] + " "+ str(i[1]) + "  " + str(i[2]))
	
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
	var needed_i = find_index_of_array(record_table, Name.name)
	record_table[needed_i][1]+=1
	needed_i = find_index_of_array(record_table, Killer_name)
	record_table[needed_i][2]+=1
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
	


func find_index_of_array(array: Array, element : String)-> int:
	for i in range(array.size()):
		if array[i][0] == element:
			return i;
	return 0
