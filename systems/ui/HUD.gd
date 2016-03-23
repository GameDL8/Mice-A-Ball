
extends CanvasLayer

onready var score_gauge = get_node("container/progress/gauge")
onready var score_label = get_node("container/score/Label")

func _ready():

	get_node("container/menu").connect("pressed",PAUSE_MENU, "pause")
	score_gauge.set_value(0)
	pass

func initialize_level(name="", max_score=1000):
	get_node("container/level_name/Label").set_text(name)
	score_gauge.set_max(max_score)
	#[0] HACK: stop player movement when mouse is over the HUD
	get_node("container").connect("mouse_enter",self, "disable_player")
	get_node("container").connect("mouse_exit",self, "enable_player")
	get_node("container/progress/gauge").connect("mouse_enter",self, "disable_player")
	get_node("container/progress/gauge").connect("mouse_exit",self, "enable_player")
	get_node("container/menu").connect("mouse_enter",self, "disable_player")
	get_node("container/menu").connect("mouse_exit",self, "enable_player")
	#[/0]

func disable_player():
	Globals.get("player").set_process_input(false)

func enable_player():
	Globals.get("player").set_process_input(true)

func show():
	get_node("container").show()

func hide():
	get_node("container").hide()