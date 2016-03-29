
extends CanvasLayer



func _ready():
	get_node("Credits/Score").set_text("Your Score: "+str(GameManager.score))
	restart()

func restart():
	yield (get_node("AnimationPlayer"),"finished")
	GameManager.achievements["has_seen_credits"] = true
	GameManager.save_game()
	GameManager.to_main_menu()