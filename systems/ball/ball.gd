
extends Area2D

#region variables
var color = 0 setget set_color,get_color

var sprite
var details
var anim

var previous_ball
var next_ball
var moving_direction = Vector2()
var offset = 0 setget set_offset,get_offset
var shoot_dir = Vector2()
var shoot_speed = 0
var path = null
var inserting = false
var insertion=1.0
var insertion_src=Vector2()
var pulling = false
var disposing = false

#region getters and setters
func set_color(col):
	if sprite == null: #HACK: when calling set_color before ready, color will be asigned later
		color = col
	else:
		sprite.set_texture(CONST.colors[col])

func get_color():
	return color

func set_offset(off):
	if off < 0:
		dispose()
	offset = off
	if (next_ball != null) && (next_ball.offset-off) < insertion*CONST.MIN_SEPARATION:
		next_ball.offset = off + insertion*CONST.MIN_SEPARATION
	if !inserting && (previous_ball != null) && (off-previous_ball.offset) < CONST.MIN_SEPARATION:
		previous_ball.offset = off - CONST.MIN_SEPARATION
	var pos = path.curve.interpolate_baked(off)
	pos.x = lerp(insertion_src.x,pos.x,insertion)
	pos.y = lerp(insertion_src.y,pos.y,insertion)
	.set_pos(pos)

func get_offset():
	return offset

#region constructors
func _ready():
	sprite = get_node("mice")
	anim = get_node("AnimationPlayer")
	details = get_node("details")
	set_color(color)
	set_fixed_process(true)
	pass

#region updaters
func _fixed_process(delta):
	if inserting:
		insertion+=delta*3
		insertion=clamp(insertion,0,1)
		if previous_ball != null && (offset-previous_ball.offset) < insertion*CONST.MIN_SEPARATION:
			set_offset(previous_ball.offset+insertion*CONST.MIN_SEPARATION) #make sure insertion updates
		else:
			set_offset(offset)
		if insertion == 1:
			get_node("notifier").disconnect("exit_screen", self, "on_exit_screen")
			Globals.get("current_level").on_ball_inserted(self,path)
			inserting = false
	elif shoot_speed > 0:
		.set_pos(get_pos()+shoot_dir*shoot_speed*delta)
	else:
		if pulling == true:
			if previous_ball==null || previous_ball.color!=color:
				pulling = false
			elif (previous_ball.offset+CONST.MIN_SEPARATION)==offset:
				pulling==false
				Globals.get("current_level").on_ball_inserted(self,path)
			else:
				var last = self
				while (last.next_ball!=null && last.next_ball.offset <= last.offset+CONST.MIN_SEPARATION):
					last = last.next_ball
				last.offset -=CONST.SPEED*2*delta
		var pos = path.curve.interpolate_baked(offset)
		pos.x = lerp(insertion_src.x,pos.x,insertion)
		pos.y = lerp(insertion_src.y,pos.y,insertion)
		.set_pos(pos)

#region functions
func set_pos(position): #function override
	moving_direction = position - get_pos()
	.set_pos(position)

func shoot(direction, speed):
	shoot_dir = direction
	shoot_speed = speed
	connect("area_enter", self, "on_collide_ball")
	get_node("notifier").connect("exit_screen", self, "on_exit_screen")

func on_exit_screen():
	Globals.get("current_level").chain_bonus=0
	queue_free()

func on_collide_ball(other):
	if other extends load("res://systems/ball/ball.gd"):
		if other.disposing:
			return
		path = other.path
		inserting=true
		insertion=0.0
		insertion_src=get_pos()
		path.balls.append(self)
		var delta_pos = get_pos()-other.get_pos()
		if moving_direction.normalized().dot(delta_pos.normalized()) < 0: #other was hit on the front
			previous_ball = other
			next_ball = other.next_ball
			if other.next_ball != null:
				other.next_ball.previous_ball = self
			else:
				path.last_ball = self #we are the next ball
			other.next_ball = self
			self.offset=other.offset+CONST.MIN_SEPARATION
		else: #other was hit on the back
			next_ball = other
			previous_ball = other.previous_ball
			if other.previous_ball != null:
				other.previous_ball.next_ball = self
			else:
				path.first_ball = self #we are the first ball
			other.previous_ball = self
			self.offset=other.offset-CONST.MIN_SEPARATION
		shoot_speed = 0
		disconnect("area_enter", self, "on_collide_ball")

func dispose(animate = false):
	if previous_ball != null:
		previous_ball.next_ball=next_ball
	if next_ball != null:
		next_ball.previous_ball=previous_ball
	if path.first_ball == self:
		path.first_ball = next_ball
	if path.last_ball == self:
		path.last_ball = previous_ball
	path.balls.remove(path.balls.find(self))
	disposing = true
	if animate:
		anim.play("dispose")
		GameManager.mices_killed +=1
		print(GameManager.mices_killed)
		yield(anim,"finished")
	if is_inside_tree():
		queue_free()

func _enter_tree():
	GameManager.balls_type[color]+=1

func _exit_tree():
	GameManager.balls_type[color]-=1