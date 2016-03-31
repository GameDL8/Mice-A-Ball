
extends CanvasLayer

var anim
var main_menu_scn = preload("res://systems/main_menu/main_menu.tscn")
var main_menu

func _ready():
	anim = get_node("AnimationPlayer")
	anim.play("default")
	main_menu = main_menu_scn.instance()
	set_process(true)
	pass
	
func _process(delta):
	get_tree().call_deferred("add_child",main_menu)
	yield (anim,"finished")
	get_tree().change_scene("res://systems/main_menu/main_menu.tscn")



