
extends Node

var lives = 3
var score = 0

func new_game():
	lives = 3
	score = 0
	get_tree().change_scene("res://levels/level1/level1.tscn")
	HUD.show()

func to_main_menu():
	get_tree().change_scene("res://systems/main_menu/main_menu.tscn")
	HUD.hide()

func game_over():
	get_tree().change_scene("res://systems/game_over/game_over.tscn")
	HUD.hide()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


