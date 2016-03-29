
extends CanvasLayer
export var title_string = "Paused"
var title
var items = {name = "",action = ""}
var panel
var menu
#states vars
onready var is_paused = false

#buttons
var restart
var music
var sfx
var quit
var share
var viewport



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	title = get_node("Panel/menu/title")
	panel = get_node("Panel")
	menu = get_node("Panel/menu")
	music = get_node("Panel/menu/options/music")
	sfx = get_node("Panel/menu/options/sfx")
	quit = get_node("Panel/menu/options/quit")
	get_node("Panel/menu/options/music/bgm_volume").connect("value_changed", self, "_on_bgm_volume_changed")
	get_node("Panel/menu/options/sfx/sfx_volume").connect("value_changed", self, "_on_sfx_volume_changed")
	title.set_text(title_string)
	get_node("Panel/menu/options/music/disabled").hide()
	get_node("Panel/menu/options/sfx/disabled").hide()
	get_node("Panel/menu/resume1").connect("pressed", self, "unpause")
	get_node("Panel/menu/options/resume").connect("pressed", self, "unpause")
	quit.connect("pressed",self,"quit_to_main_menu") #TODO: popup a question
	panel.hide()
	pass

#For the future, implement a menu system that creates itself at runtime based on
#a dictionary.
func create_items (items_dict):
	for item in items_dict:
		pass

func pause():
	get_tree().set_pause(true)
	is_paused = true
	title.set_text(title_string)
	panel.show()

func unpause():
	get_tree().set_pause(false)
	is_paused = false
	panel.hide()

func quit_to_main_menu():
	unpause()
	GameManager.to_main_menu()

func goto_scene(scene):
	var s = scene.instance()
	scene.queue_free()
	get_tree().get_root().call_deferred("add_child", s)

func load_and_goto_scene(scene):
	var s = load(scene)
	var si = s.instance()
	get_tree().get_root().call_deferred("add_child", si)
	queue_free()

func _on_music_pressed():
	if CONST.MUSIC:
		AudioServer.set_stream_global_volume_scale(0)
		CONST.MUSIC = false
		get_node("Panel/menu/options/music/disabled").show()
	elif not CONST.MUSIC:
		AudioServer.set_stream_global_volume_scale(get_node("Panel/menu/bgm_volume").get_val())
		CONST.MUSIC = true
		get_node("Panel/menu/options/music/disabled").hide()
	pass # replace with function body

func _on_bgm_volume_changed(val):
	if CONST.MUSIC:
		AudioServer.set_stream_global_volume_scale(val)

func _on_sfx_volume_changed(val):
	if CONST.SFX:
		AudioServer.set_fx_global_volume_scale(val)

func _on_sfx_pressed():
	if CONST.SFX:
		AudioServer.set_fx_global_volume_scale(0)
		CONST.SFX = false
		get_node("Panel/menu/options/sfx/disabled").show()
	elif not CONST.SFX:
		AudioServer.set_fx_global_volume_scale(get_node("Panel/menu/sfx_volume").get_value())
		CONST.SFX = true
		get_node("Panel/menu/options/sfx/disabled").hide()
	pass # replace with function body
