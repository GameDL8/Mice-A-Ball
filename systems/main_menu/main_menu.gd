
extends CanvasLayer

func _ready():
	get_node("menu/options/new_game").connect("pressed",GameManager,"new_game")
	get_node("menu/options/quit").connect("pressed",get_tree(),"quit")
	HUD.hide()


