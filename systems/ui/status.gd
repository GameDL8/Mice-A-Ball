extends CanvasLayer
var time
var total_time
var score
var next_level
var restart
var panel
func _ready():
	score = get_node("Panel/menu/options/score")
	time = get_node("Panel/menu/options/time")
	total_time = get_node("Panel/menu/options/total_time")
	next_level = get_node("Panel/menu/options/next_level")
	restart = get_node("Panel/menu/options/restart")
	panel = get_node("Panel")
	panel.hide()

func update():
#	Time	
	var hours = GameManager.time["seconds"]/3600 # Convert to hours
	var minutes = (hours%1)*60
	var seconds = (minutes%1)*60
	if seconds >=60:
		seconds -=60
		minutes+=1
	
	if minutes >= 60:
		minutes-=60
		hours+=1
	GameManager.total_time["hours"]+=hours
	GameManager.total_time["minutes"]+=minutes
	GameManager.total_time["seconds"]+=seconds
	
	#Adding new time to total_time:
	if GameManager.total_time["seconds"]>=60:
		GameManager.total_time["seconds"] -=60
		GameManager.total_time["minutes"]+=1
	#Adding score to total score:
	GameManager.total_score += GameManager.score
	
func display():
	update()
	panel.show()
	score.set_text(score.get_text()+ str(GameManager.score))
	time.set_text(time.get_text()+ str(GameManager.time["minutes"])+":"+str(GameManager.time["seconds"]))