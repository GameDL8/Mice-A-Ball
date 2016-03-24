
extends Control

func setup(score, chain = 0, combo = 0):
	var pitch = 0.8
	var text = "+"+str(score)
	if chain >= CONST.CHAINS_FOR_BONUS:
		text += "\nCHAIN BONUS x"+str(chain)
		pitch += 0.05*(chain-CONST.CHAINS_FOR_BONUS)
	if combo > 0:
		text += "\nCOMBO BONUS x"+str(combo)
	get_node("SamplePlayer").set_default_pitch_scale(pitch)
	get_node("SamplePlayer").play("gain_life")
	get_node("Label").set_text(text)

func set_color(color):
	get_node("Label").add_color_override("font_color",color)
