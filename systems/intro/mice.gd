
extends Sprite
var anim
var modifier = 0
func _ready():
	if GameManager.achievements["has_seen_credits"]:
		modifier = 4
	anim = get_node("anim")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func play():
	if randi()%20 >14-modifier:
		anim.play(anim.get_animation_list()[randi() % anim.get_animation_list().size()])