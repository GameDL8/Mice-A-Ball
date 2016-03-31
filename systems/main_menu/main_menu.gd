extends CanvasLayer

var plus_signs=""
func _ready():
	if GameManager.times_finished > 0:
		for i in range(GameManager.times_finished):
			plus_signs +="+"
	
	if GameManager.times_finished >= 10:
		plus_signs="+"+str(GameManager.times_finished)
	print(plus_signs)
	
	get_node("menu/options/new_game/Label").set_text(get_node("menu/options/new_game/Label").get_text()+plus_signs)
	get_node("menu/options/new_game").connect("pressed",GameManager,"new_game")
	get_node("menu/options/quit").connect("pressed",get_tree(),"quit")
	HUD.hide()
