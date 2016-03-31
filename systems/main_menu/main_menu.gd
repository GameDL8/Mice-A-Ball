
extends CanvasLayer

func _ready():
	if GameManager.new_game_plus:
		get_node("menu/options/new_game/Label").set_text(get_node("menu/options/new_game/Label").get_text()+"+")
	get_node("menu/options/new_game").connect("pressed",GameManager,"new_game")
	get_node("menu/options/quit").connect("pressed",get_tree(),"quit")
	HUD.hide()
