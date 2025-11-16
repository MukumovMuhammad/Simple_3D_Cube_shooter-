extends Control
var logs : Array
@onready var info_label: Label = $Label

func write_to_log(info: String):
	logs.insert(0, info)
	var text = ""
	for i in logs:
		text = str(i) + "\n" +  text
	
	info_label.text = text
