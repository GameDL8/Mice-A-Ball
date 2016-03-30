
extends CanvasLayer

var anim
var main_menu_scn = preload("res://systems/main_menu/main_menu.tscn")
var main_menu

func _ready():
	anim = get_node("AnimationPlayer")
	anim.play("default")
	main_menu = main_menu_scn.instance()
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
	
func _process(delta):
	yield (anim,"finished")
	get_tree().call_deferred("add_child",main_menu)
	GameManager.to_main_menu()



