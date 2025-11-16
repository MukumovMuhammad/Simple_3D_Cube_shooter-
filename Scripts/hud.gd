extends Control
var logs : Array
@onready var info_label: Label = $Label

func write_to_log(info: String):
	info_label.text = info + "\n" + info_label.text
	#logs.append(info)
	#var text = ""
	#for i in range(clamp(logs.size(), 0,5) -1 ,-1, -1):
		#text += logs[i] + "\n"
	#
	#info_label.text = text
