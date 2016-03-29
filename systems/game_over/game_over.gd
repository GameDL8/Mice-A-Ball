
extends CanvasLayer



func _ready():
	get_node("Credits/Score").set_text("Your Score: "+str(GameManager.score))
	restart()

func restart():
	yield (get_node("AnimationPlayer"),"finished")
	GameManager.to_main_menu()