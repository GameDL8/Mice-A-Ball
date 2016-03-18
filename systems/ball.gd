
extends Area2D
export  var color = Color(1,1,1,1)
# member variables here, example:
# var a=2
# var b="textvar"
var sprite
var anim
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	sprite = get_node("AnimatedSprite")
	anim = get_node("AnimationPlayer")
	set_process(true)
	print(sprite.get_modulate())
	sprite.set_modulate(color)
	pass

func _process(delta):
	