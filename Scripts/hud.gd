extends Control
var logs : Array
@onready var info_label: Label = $Label
@onready var table: VBoxContainer = $table
@onready var items: ItemList = $table/items


func _ready() -> void:
	table.visible = false


func _process(delta: float) -> void:
	if Input.is_action_pressed("tab"):
		table.visible = true
	else:
		table.visible = false
	

func add_items_to_table(array: Array)->void:
	for i in array:
		items.add_item(i[0])
		items.add_item(str(i[1]))
		items.add_item(str(i[2]))
	
	for i in range(items.item_count):
		items.set_item_disabled(i,true)
	
func modify_item(item_i:int, updated_value : int, bias : int):
	#0 1 2
	#3 4 5 = 0
	#6 7 8 = 1
	#9 10 11 = 2
	#12 13 14 = 3
	
	items.set_item_text(item_i * 3 + 3 + bias, str(updated_value))

func write_to_log(info: String):
	info_label.text = info + "\n" + info_label.text
	#logs.append(info)
	#var text = ""
	#for i in range(clamp(logs.size(), 0,5) -1 ,-1, -1):
		#text += logs[i] + "\n"
	#
	#info_label.text = text
