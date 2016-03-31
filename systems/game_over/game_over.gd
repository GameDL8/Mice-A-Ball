
extends CanvasLayer
var trivia = ["Get +1 life:\n up,up,down,right,left","Enable debug mode:\nup,up,down,down,left,right,left,right","Look behind you!\n(No need for thanks :) )", "No Blue Rhinella schneideri were harmed during the production of this game.","Some programmers were harmed during the making of this game","It was planned for us to add an achievement system but time constrains made us scrap the idea.","Improve your memory by doing unforgettable things",""]
var chances_modifier = 0
func _ready():
	print("Current level value: ",GameManager.current_level)
	#	The original New game plus was disabled due to time constrains	
#	On its place, a system that keeps building the speed of the level
#	by increments of 10% for each time the player finishes the game
#	in a row was set. Those incremments are lost when the player quits
#	the game.
	if GameManager.current_level >= GameManager.levels.size():
		GameManager.times_finished+=1
		get_node("Credits/GameOver").set_text("CONGRATULATIONS!")
		print("Congratulations was set")
		GameManager.current_level = 0
#		GameManager.new_game_plus = !GameManager.new_game_plus
	
	set_process_input(true)
	if GameManager.achievements["has_seen_credits"]:
		chances_modifier = 2
	if randi() %10 > 4-chances_modifier :
		var selected_trivia = trivia[randi() % trivia.size()]
		print(selected_trivia, " trivia will be displayed")
		get_node("Credits/Credits").set_bbcode(get_node("Credits/Credits").get_bbcode()+"[center]" +"You're still here? Wow! We're flattered!\nAs thanks, we'd like to tell you something:\n"+selected_trivia )
	get_node("Credits/Score").set_text("Your Score: "+str(GameManager.score))
	
	restart()

func restart():
	yield (get_node("AnimationPlayer"),"finished")
	GameManager.achievements["has_seen_credits"] = true
	GameManager.save_game()
	GameManager.to_intro()
	
func _input(ev):
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == 1 and ev.pressed:
		get_node("AnimationPlayer").set_speed(10)
	else:
		get_node("AnimationPlayer").set_speed(1)