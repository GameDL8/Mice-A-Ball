extends CanvasLayer
var time
var score
var ranking
var next_level
var restart
var panel
var level
var hours = 0
var minutes = 0
var seconds = 0

func _ready():
	add_user_signal("can_continue")
	score = get_node("Panel/menu/options/score")
	time = get_node("Panel/menu/options/time")
	ranking = get_node("Panel/menu/options/ranking")
	next_level = get_node("Panel/menu/options/next_level")
	restart = get_node("Panel/menu/options/restart")
	panel = get_node("Panel")
	panel.hide()
	GameManager.load_game()
	set_process_input(true)

func update():
	GameManager.get_level_file_name()
#	Time	
	hours = GameManager.time["seconds"]/3600 # Convert to hours
	minutes = (hours%1)*60
	seconds = (minutes%1)*60
	if seconds >=60:
		seconds -=60
		minutes+=1
	
	if minutes >= 60:
		minutes-=60
		hours+=1
	
	#Adding new time to total_time:
	if seconds >=60:
		seconds -=60
		minutes +=1

	if GameManager.times_played_by_level[get_level_by_index(0)] > 5 and GameManager.times_played_by_level[get_level_by_index(0)] > GameManager.times_played_by_level[get_level_by_index(1)]*1.5:
		if not GameManager.achievements["noob_cat"]:
			GameManager.ranking = "Noob Cat"
			GameManager.achievements["noob_cat"] = true
			
	elif GameManager.times_played_by_level[get_level_by_index(0)] > 100 and GameManager.total_time["seconds"] > 7200:
			GameManager.ranking = "Nyandertal"
			GameManager.achievements["nyandertal"] = true
	
	elif GameManager.time["seconds"] < 300:
			GameManager.ranking = "Thunder-Cat"
			GameManager.achievements["thundercat"] = true
		

#	GameManager.ranking

func _input(ev):
	if (CONST.DEBUG):
		if ev.type == InputEvent.KEY && ev.scancode==KEY_0 && ev.pressed:
			display()


func show():
	update()
	panel.show()
	score.set_text("score: "+ str(GameManager.score))
	time.set_text("Time: "+ str(minutes)+":"+str(seconds))
	ranking.set_text("Ranking: "+GameManager.ranking)

func hide():
	panel.hide()

func get_level_by_index(index):
	var level = GameManager.levels[index].split("/")
	level = level[level.size()-1].split(".")[0]
	print("level on status function =",level)
	return level

func _on_next_level_pressed():
	GameManager.current_level+=1
	emit_signal("can_continue")
	hide()
	pass


func _on_restart_pressed():
	Globals.get("current_level").restart()
	emit_signal("can_continue")
	hide()
	pass
