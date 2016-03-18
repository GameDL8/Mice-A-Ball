tool

extends Area2D

export(int,"Red,Green,Blue,Yellow") var color = 0 setget set_color,get_color

#copypaste from CONST to use inside editor
const colors = [
Color(0.9375,0.102539,0.239525),
Color(0.069916,0.617188,0.091294),
Color(0.247162,0.439194,0.710938),
Color(0.949219,0.885547,0.367081)
]

var sprite
var anim

var previous_ball
var next_ball
var offset = 0 setget set_offset,get_offset

func set_color(color):
	if (is_inside_tree()):
		get_node("AnimatedSprite").set_modulate(colors[color])
		print(str(colors[color]))

func get_color():
	return color

func set_offset(off):
	offset = off
	if (next_ball != null) && (next_ball.offset-off) < CONST.MIN_SEPARATION:
		next_ball.offset = off + CONST.MIN_SEPARATION
	if (previous_ball != null) && (off-previous_ball.offset) < CONST.MIN_SEPARATION:
		previous_ball.offset = off - CONST.MIN_SEPARATION

func get_offset():
	return offset

func _ready():
	set_color(color)
	sprite = get_node("AnimatedSprite")
	anim = get_node("AnimationPlayer")
	pass

func _process(delta):
	if get_tree().is_editor_hint():
		return
