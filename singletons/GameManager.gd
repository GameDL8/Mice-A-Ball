
extends Node
var save_file = "user://save.sav"
var save
var lives = 3
var score = 0
var level_score = 0
var time = {"hours":0,"minutes":0,"seconds":0}
var total_time = {"hours":0,"minutes":0,"seconds":0}
var times_played_by_level = {}
var consecutive_loss
var loss_by_level = {}
var total_score=0
var score_by_level = {}
var mices_killed_by_level = {}
var mices_killed = 0
var times_cheated = 0
var times_cheated_by_level ={}
var times_lost_by_level = {}
var ranking ="Noob Cat"
const levels = [
"res://levels/level1/level1.tscn",
"res://levels/level2/level2.tscn"
]
var current_level = 0
var balls_type=[0,0,0,0]
var score_to_win = 0
func _init():
	#Loading save file
	save = ConfigFile.new()
	save.load(save_file)
	if save.has_section("config"):
		print(save_file)
		total_score = save.get_value("player","total_score",0)
		ranking = save.get_value("player","ranking","Noob Cat")
		total_time.hours = save.get_value("player","hours",0)
		total_time.minutes = save.get_value("player","minutes",0)
		total_time.seconds = save.get_value("player","seconds",0)
		mices_killed = save.get_value("player","mices_killed",0)
#	Loop to get the times played on a level	
		for level in levels:
			# First it splits each path of the levels array using / as an separator
			var result = level.split("/")
			# Then it does its magic:
			times_played_by_level[result[result.size()-1].split(".")[0]] = save.get_value("times_played_by_level",result[result.size()-1].split(".")[0],0)
			mices_killed_by_level[result[result.size()-1].split(".")[0]] = save.get_value("mices_killed_by_level",result[result.size()-1].split(".")[0],0)
	else:
		save.set_value("config", "initialized",true)
		save.save(save_file)
		print("New file saved to ",save_file)
func new_game():
	balls_type=[0,0,0,0]
	lives = 3
	score = 0
	level_score = 0
	current_level = 0
	HUD.score_label.set_text("0")
	get_tree().change_scene(levels[0])
	HUD.show()
	time = {"hours":0,"minutes":0,"seconds":0}
	

func advance_level():
	current_level+=1
	level_score = 0
	if current_level < levels.size():
		get_tree().change_scene(levels[current_level])
	else:
		get_tree().change_scene("res://systems/game_over/game_over.tscn")

func to_main_menu():
	get_tree().change_scene("res://systems/main_menu/main_menu.tscn")
	HUD.hide()

func game_over():
	get_tree().change_scene("res://systems/game_over/game_over.tscn")
	HUD.hide()

func on_lose():
	lives-=1
	level_score=0
	time = {"hours":0,"minutes":0,"seconds":0}
	balls_type =[0,0,0,0]
	HUD.set_lives(lives)
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


