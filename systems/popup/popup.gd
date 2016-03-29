
extends Node
var frame
var text
# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	frame = get_node("Patch9Frame")
	text = get_node("RichTextLabel")
	frame.hide()
	text.set_use_bbcode(true)
	text.set_bbcode("It [size=14]g[/size][size=18]r[/size][size=22]o[/size][size=26]o[/size][size=28]w[/size][size=32]s[/size]!!!")
	pass


func show():
	frame.show()