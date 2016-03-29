
extends Node
var save_file = "user://save_game.sav"
var save_game
var lives = 3
var score = 0
var level_score = 0
# Reset to zero after each new level or loss:
var time = {"hours":0,"minutes":0,"seconds":0}
var total_time = {"hours":0,"minutes":0,"seconds":0}
var times_played_by_level = {}
var consecutive_loss = 0
var loss_by_level = {}
var total_score=0
var total_scores_by_level = {}
var mices_killed_by_level = {}
var times_cheated = 0
var mices_killed_in_currenct_level = 0
var ranking ="Cute little Kitten"

#Achievements are set here and loaded dinamically by the program, if you
# want to create one, just add it here and set its default value to false
var achievements = {
	"pur":false,
	"noob_cat":false,
	"this_shouldnt_be_here":false,
	"nyandertal": false,
	"smelly_cats":false,
	"all_cats_go_to_heaven":false,
	"thundercat":false,
	}
const levels = [
"res://levels/level1/level1.tscn",
"res://levels/level2/level2.tscn"
]
var current_level = 0
var balls_type=[0,0,0,0]
var score_to_win = 0
func _init():
	#Loading save file
	load_game()

func new_game():
#	var level = level.s
	balls_type=[0,0,0,0]
	lives = 3
	score = 0
	level_score = 0
	current_level = 0
	Globals.set("level_file_path",levels[current_level])
	print(Globals.get("level_file_path"))
	HUD.score_label.set_text("0")
	get_tree().change_scene(levels[0])
	HUD.show()
	time = {"hours":0,"minutes":0,"seconds":0}

func save_game():
	print(save_file)
	print("Level filename: ",str(get_level_file_name()))
	save_game = ConfigFile.new()
	save_game.load(save_file)
	save_game.set_value("player","total_score",total_score)
	save_game.set_value("player","ranking",ranking)
	save_game.set_value("player","hours",total_time.hours)
	save_game.set_value("player","minutes",total_time.minutes)
	save_game.set_value("player","seconds",total_time.seconds)
	save_game.set_value("player","consecutive_loss",consecutive_loss)
	save_game.set_value("player","times_cheated",times_cheated)

#		Achievements:
	for key in achievements:
		save_game.set_value("achievements", key, achievements[key])
		save_game.save(save_file)
#	Loop to get the times played on a level	
	for level in levels:
		# First it splits each path of the levels array using / as an separator
		var result = level.split("/")
		var level_name= result[result.size()-1].split(".")[0]
		print(level_name)
		# Then it does its magic:
		save_game.set_value("times_played_by_level",level_name,times_played_by_level[level_name])
		save_game.set_value("mices_killed_by_level",level_name,mices_killed_by_level[level_name])
		save_game.set_value("loss_by_level",level_name,loss_by_level[level_name])
		save_game.set_value("total_scores_by_level",level_name,total_scores_by_level[level_name])
	pass

func load_game():
	print(save_file)
	save_game = ConfigFile.new()
	save_game.load(save_file)
	total_score = save_game.get_value("player","total_score",0)
	ranking = save_game.get_value("player","ranking","Noob Cat")
	total_time.hours = save_game.get_value("player","hours",0)
	total_time.minutes = save_game.get_value("player","minutes",0)
	total_time.seconds = save_game.get_value("player","seconds",0)
	consecutive_loss = save_game.get_value("player","consecutive_loss",0)
	times_cheated = save_game.get_value("player","times_cheated",0)

#		Achievements:
	for key in achievements:
		achievements[key] = save_game.get_value("achievements", key, false)
#	Loop to get the times played on a level	
	for level in levels:
		# First it splits each path of the levels array using / as an separator
		var result = level.split("/")
		var level_name= result[result.size()-1].split(".")[0]
		print(level_name)
		# Then it does its magic:
		times_played_by_level[level_name] = save_game.get_value("times_played_by_level",level_name,0)
		mices_killed_by_level[level_name] = save_game.get_value("mices_killed_by_level",level_name,0)
		loss_by_level[level_name] = save_game.get_value("loss_by_level",level_name,0)
		total_scores_by_level[level_name] = save_game.get_value("total_scores_by_level",level_name,0)
	pass

func advance_level():
	var level = get_level_file_name()
	print(level)
	consecutive_loss = 0
	total_scores_by_level[level]+=level_score
	times_played_by_level[level] += 1
	mices_killed_by_level[level] +=mices_killed_in_currenct_level
	total_time.hours += time.hours
	total_time.minutes += time.minutes
	total_time.seconds += time.seconds
	save_game()
	STATUS.show()
	yield(STATUS,"can_continue")
	# All status related to the level when the player wins should be updated before
	#the next line:
	Globals.set("level_file_path",levels[current_level])
	level_score = 0
	mices_killed_in_currenct_level = 0
	time = {"hours":0,"minutes":0,"seconds":0}
	if current_level < levels.size():
		get_tree().change_scene(levels[current_level])
	else:
		get_tree().change_scene("res://systems/game_over/game_over.tscn")

func to_main_menu():
	get_tree().change_scene("res://systems/main_menu/main_menu.tscn")
	HUD.hide()

func game_over():
	save_game()
	get_tree().change_scene("res://systems/game_over/game_over.tscn")
	HUD.hide()

func on_lose():
	var level = get_level_file_name()
	loss_by_level[level] += 1
	consecutive_loss +=1
	times_played_by_level[level] += 1
	total_time.hours += time.hours
	total_time.minutes += time.minutes
	total_time.seconds += time.seconds
	lives-=1
	level_score=0
	time = {"hours":0,"minutes":0,"seconds":0}
	balls_type =[0,0,0,0]
	HUD.set_lives(lives)
	save_game()
	if lives==0:
		game_over()
	else:
		Globals.get("current_level").restart()

func add_score(_score):
	score +=_score
	level_score += _score
	HUD.score_label.set_text(str(score))
	HUD.score_gauge.set_value(level_score)
	var level = Globals.get("current_level")
	if level_score >= level.score_to_win && level.state == CONST.STATE_PLAYING:
		Globals.get("current_level").state = CONST.STATE_SCORED

func get_level_file_name():
	var level = Globals.get("level_file_path")
	level = level.split("/")
	print("This is level_file_path: ", level)
	return level[level.size()-1].split(".")[0]