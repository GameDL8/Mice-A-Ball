
extends Area2D
var color = 0 setget set_color,get_color

var sprite
var details
var anim

var previous_ball
var next_ball
var offset = 0 setget set_offset,get_offset

func set_color(col):
	if sprite == null: #HACK: when calling set_color before ready, color will be asigned later
		color = col
	else:
		sprite.set_modulate(CONST.colors[col])

func get_color():
	return color

func set_offset(off):
	if off < 0:
		if next_ball != null:
			next_ball.previous_ball=null
		emit_signal("disposed", self)
		queue_free()
		return
	offset = off
	if (next_ball != null) && (next_ball.offset-off) < CONST.MIN_SEPARATION:
		next_ball.offset = off + CONST.MIN_SEPARATION
	if (previous_ball != null) && (off-previous_ball.offset) < CONST.MIN_SEPARATION:
		previous_ball.offset = off - CONST.MIN_SEPARATION

func get_offset():
	return offset

func _init():
	var arg = {}
	arg["type"] = TYPE_OBJECT
	arg["name"] = "who"
	add_user_signal("disposed", [arg]);

func _ready():
	sprite = get_node("AnimatedSprite")
	anim = get_node("AnimationPlayer")
	details = get_node("details")
	set_color(color)
	pass