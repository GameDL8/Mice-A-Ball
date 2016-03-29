
extends CanvasLayer

onready var score_gauge = get_node("container/progress/gauge")
onready var score_label = get_node("container/score/Label")
onready var lives_label = get_node("container/lives/Label1")

func _ready():
	get_node("container/menu").connect("pressed",PAUSE_MENU, "pause")
	score_gauge.set_value(0)
	pass

func initialize_level(name="", max_score=1000):
	get_node("container/level_name/Label").set_text(name)
	score_gauge.set_max(max_score)
	score_gauge.set_value(0)

func disable_player():
	if Globals.get("player") != null:
		if Globals.get("player").is_inside_tree():
			Globals.get("player").set_process_input(false)

func enable_player():
	if Globals.get("player") != null:
		if Globals.get("player").is_inside_tree():
			Globals.get("player").set_process_input(true)

func set_lives(lives):
	lives_label.set_text("x "+str(lives))

func show():
	get_node("container").show()

func hide():
	get_node("container").hide()