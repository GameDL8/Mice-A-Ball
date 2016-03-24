
extends Node

var lives = 3
var score = 0
var level_score = 0

const levels = [
"res://levels/level1/level1.tscn",
"res://levels/level2/level2.tscn"
]
var current_level = 0

func new_game():
	lives = 3
	score = 0
	level_score = 0
	current_level = 0
	HUD.score_label.set_text("0")
	get_tree().change_scene(levels[0])
	HUD.show()

func advance_level():
	current_level+=1
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

func add_score(_score):
	score +=_score
	level_score += _score
	HUD.score_label.set_text(str(score))
	HUD.score_gauge.set_score(level_score)
	var level = Globals.get("current_level")
	if level_score >= level.score_to_win && level.state == CONST.STATE_PLAYING:
		Globals.get("current_level").state = CONST.STATE_SCORED


