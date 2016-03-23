
extends CanvasLayer



func _ready():
	restart()

func restart():
	yield (get_node("AnimationPlayer"),"finished")
	GameManager.to_main_menu()