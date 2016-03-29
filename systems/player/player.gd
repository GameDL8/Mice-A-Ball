
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
	if not GameManager.ignore_input:
		if ev.type == InputEvent.MOUSE_MOTION:
			look_at(get_node("/root").get_mouse_pos())
		if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == 1 and ev.pressed:
			look_at(get_node("/root").get_mouse_pos())
			if (get_node("/root").get_mouse_pos()-get_pos()).length_squared() > 2500:
				if (get_node("/root").get_mouse_pos().y > 50): #HACK: ignore clicks over the HUD
					shoot()
			else:
				var aux = curr_color
				self.curr_color=next_color
				self.next_color=aux
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
#	for ball in get_n
	self.next_color = randi() % 4
	#BUG: Sometimes the game crashes, I believe it has something to do with the ball types detection
	var total_balls = 0
	for count in GameManager.balls_type:
		total_balls += count
	while total_balls > 0 && GameManager.level_score >= GameManager.score_to_win && GameManager.balls_type[next_color] == 0:
		next_color = randi() % 4
	self.next_color = next_color
	Globals.get("current_level").call_deferred("add_child",ball)
	anim.play("shoot")

func enter_scored_phase():
	GameManager.connect("color_cleared", self, "_on_color_cleared")

func _on_color_cleared(col):
	if GameManager.level_score < GameManager.score_to_win:
		return
	var total_balls = 0
	for count in GameManager.balls_type:
		total_balls += count
	if total_balls == 0:
		curr_color_sprite.hide()
		next_color_sprite.hide()
		return
	if next_color==col:
		while GameManager.balls_type[next_color] == 0:
			next_color = randi() % 4
	if curr_color==col:
		while GameManager.balls_type[curr_color] == 0:
			curr_color = randi() % 4
	self.next_color=next_color
	self.curr_color=curr_color