extends Node2D

var combinations =[
["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right"],
]

#var combinations =[
#["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_cancel","ui_accept"]
#]
var states = [0]

var actions = []

func _ready():
	set_process_input(true)

func _input(ev):
	if ev.type == InputEvent.KEY && ev.pressed && !ev.is_echo():
		for i in range(states.size()):
			if InputMap.event_is_action(ev,combinations[i][states[i]]):
				states[i]+=1
				if states[i]==combinations[i].size():
					call("cheat_"+str(i))
					GameManager.times_cheated+=1 #For status
					print("cheat enabled: "+str(i))
					states[i]=0
			else:
				states[i]=0

func cheat_0():
	CONST.DEBUG = !CONST.DEBUG
	print("Debug Mode: "+str(CONST.DEBUG))
