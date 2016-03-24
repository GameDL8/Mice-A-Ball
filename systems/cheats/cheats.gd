
extends Node
var inputs = ["ui_up","ui_down","ui_left","ui_right","ui_cancel","ui_accept"]
#var cheats_db = {
#	"konamicode" : ["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"],
#	"konamicode2" : ["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"],
#	"useless_code" : ["ui_down","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"],
#	"another useless code" : ["ui_left","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"]
#	}

var cheats_db = {
	"konamicode" : [65,65,65,65,65,65,65,65,65,65],
	"konamicode2" : ["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"],
	"useless_code" : ["ui_down","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"],
	"another useless code" : ["ui_left","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_left","ui_cancel","ui_left","ui_accept"]
	}
var buffer = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var buffer_max_size = 25
var cheat_started = false
func _ready():
	set_process_input(true)
	pass

func _input(event):
	if buffer.size() >buffer_max_size:
		buffer.pop_front()
	if event.type==InputEvent.KEY && not event.is_echo() && event.pressed: #any key pressed
		buffer.append(event.ID)
	print(buffer)
	for cheat in cheats_db:
		var check_cheats = []
		if buffer.size() >= cheats_db[cheat].size():
			var v=buffer_max_size - cheats_db[cheat].size()
			for i in range(cheats_db[cheat].size()):
				check_cheats.append(buffer[v])
				v+=1
			print("Check_cheats: ",check_cheats)
			for button in cheats_db[cheat]:
				check_cheats.append(buffer)