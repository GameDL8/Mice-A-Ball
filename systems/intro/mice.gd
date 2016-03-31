
extends Sprite
var anim
var modifier = 0
func _ready():
	randomize()
	set_texture(CONST.colors[randi() % CONST.colors.size()])
	if GameManager.achievements["has_seen_credits"]:
		modifier = 4
	anim = get_node("anim")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func play():
	if randi()%20 >10-modifier:
		randomize()
		var r_anim = randi() % anim.get_animation_list().size()
		print(anim.get_animation_list())
		print(anim.get_animation_list()[r_anim])
		print(r_anim, anim.get_animation_list().size())
		anim.play(anim.get_animation_list()[r_anim])