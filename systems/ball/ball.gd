tool

extends Area2D
var color = 0 setget set_color,get_color
#copypaste from CONST to use inside editor
var colors

var sprite
var details
var anim

var previous_ball
var next_ball
var offset = 0 setget set_offset,get_offset

func set_color(color):
	if (is_inside_tree()):
		sprite.set_modulate(colors[color])
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
	sprite = get_node("AnimatedSprite")
	anim = get_node("AnimationPlayer")
	details = get_node("details")
	colors = CONST.colors
	set_color(color)
	pass

func _init():
	color = floor(rand_range(0,CONST.colors.size()))
	pass

func _process(delta):
	if get_tree().is_editor_hint():
		return