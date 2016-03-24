
extends Control

func setup(score, chain = 0, combo = 0):
	var text = "+"+str(score)
	if chain >= CONST.CHAINS_FOR_BONUS:
		text += "\nCHAIN BONUS x"+str(chain)
	if combo > 0:
		text += "\nCOMBO BONUS x"+str(combo)
	get_node("Label").set_text(text)


