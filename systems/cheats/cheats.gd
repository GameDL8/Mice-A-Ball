extends Node2D

var combinations =[
["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right"],
["ui_up","ui_up","ui_down","ui_right","ui_left"]
]

#var combinations =[
#["ui_up","ui_up","ui_down","ui_down","ui_left","ui_right","ui_left","ui_right","ui_cancel","ui_accept"]
#]
var states = [0,0]

var actions = []

func _ready():
	set_process_input(true)

func _input(ev):
	assert (combinations.size() == states.size())
	if ev.type == InputEvent.KEY && ev.pressed && !ev.is_echo():
		for i in range(states.size()):
			if InputMap.event_is_action(ev,combinations[i][states[i]]):
				states[i]+=1
				if states[i]==combinations[i].size():
					call("cheat_"+str(i))
					GameManager.times_cheated+=1 #For status
					print("cheat enabled: "+str(i))
					print("You cheater!")
					states[i]=0
			else:
				states[i]=0
				
#	Global cehats
	if CONST.DEBUG:
#		Go to intro by pressing I
		if ev.type == InputEvent.KEY && ev.scancode==KEY_I && ev.pressed:
			GameManager.to_intro()
		if ev.type == InputEvent.KEY && ev.scancode==KEY_N && ev.pressed:
			GameManager.new_game_plus = !GameManager.new_game_plus
			print("New Game Plus is :", GameManager.new_game_plus)

func cheat_0():
	CONST.DEBUG = !CONST.DEBUG
	print("Debug Mode: "+str(CONST.DEBUG))

func cheat_1():
	GameManager.lives +=1
	HUD.lives_label.set_text(str(GameManager.lives))
	print("Added one life: "+str(CONST.DEBUG))
