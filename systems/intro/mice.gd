
extends Sprite
var anim
func _ready():
	anim = get_node("anim")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func play():
	if randi()%20 >14:
		anim.play(anim.get_animation_list()[randi() % anim.get_animation_list().size()])