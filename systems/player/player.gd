
extends Node2D

#region variables
var ball_scn=preload("res://systems/ball/ball.tscn")

onready var anim = get_node("AnimationPlayer")

var curr_color setget set_curr_color,get_curr_color
onready var curr_color_sprite = get_node("current")

var next_color setget set_next_color,get_next_color
onready var next_color_sprite = get_node("AnimatedSprite/next")

var current_shoot_speed = CONST.SHOOT_SPEED

#region getters and setters
func set_curr_color(val):
	curr_color=val
	curr_color_sprite.set_texture(CONST.colors[val])
func get_curr_color():
	return curr_color

func set_next_color(val):
	next_color=val
	next_color_sprite.set_texture(CONST.colors[val])
func get_next_color():
	return next_color

#region constructors
func _init():
	Globals.set("player", self)

func _ready():
	set_process_input(true)
	self.curr_color = randi() % 4
	self.next_color = randi() % 4
	pass

#region updaters
func _input(ev):
	if ev.type == InputEvent.MOUSE_MOTION:
		look_at(get_node("/root").get_mouse_pos())
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == 1 and ev.pressed:
		shoot()
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == 2 and ev.pressed:
		var aux = curr_color
		self.curr_color=next_color
		self.next_color=aux

#region functions
func shoot():
	var mpos = get_node("/root").get_mouse_pos()
	var dir = (mpos-get_pos()).normalized()
	var ball = ball_scn.instance()
	ball.set_pos(get_global_pos()+dir*CONST.SHOOT_DISTANCE);
	ball.shoot(dir,current_shoot_speed)
	ball.color = curr_color
	self.curr_color = next_color
	self.next_color = randi() % 4
	get_tree().get_root().call_deferred("add_child",ball)
	anim.play("shoot")
	