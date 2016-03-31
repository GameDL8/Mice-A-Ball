
extends Node2D

#region variables
export(String) var level_name = "KITCHEN"
export(int) var score_to_win = 1000
export(int,FLAGS,"Red,Green,Blue,Yellow") var colors = 7
export(IntArray) var color_generator_amounts = [1,1,2,2,2,3,3,3,3,4,4,5,6] #BugDetected: IntArray can't have a default value
# The speed which the balls will go during a level
export (int) var SPEED
# Time in seconds that the player will have to wait at the start of
# the level for balls to go along the path before having the control
export (int) var wait_time = 3
var wait_timer
var has_waited = false

var state = CONST.STATE_PLAYING
var chain_bonus = 0
var paths = []
var direction = CONST.DIR_FORWARD
var timer
var time_scale = 1

var player_timer

#region subclasses
class LevelPath:
	var curve
	var balls = []
	var first_ball
	var last_ball
	var gen_ball_count = -1
	var colors = 0
	var color_generator_amounts = []
	var next_color = -1
	var cleared = false
	var cleared_pos = 0
	func get_next_color():
		if gen_ball_count <= 0:
			gen_ball_count = color_generator_amounts[floor(rand_range(0,color_generator_amounts.size()))]
			var new_color = next_color
			while !(colors in [0,1,2,4,8]) && new_color == next_color: #make sure the color changes
				var col = []
				for c in range(4):
					if (colors&int(pow(2,c))):
						col.append(c)
				new_color = col[rand_range(0,col.size())]
			next_color=new_color
		gen_ball_count-=1
			
		return next_color

#region preload
var ball_scn = preload("res://systems/ball/ball.tscn")
var score_label_scn = preload("res://systems/score_label/score_label.tscn")
var explosion_scn = preload("res://systems/explosion/explosion.tscn")



#region constructors
func _init():
	randomize()
	Globals.set("current_level", self)
	GameManager.score_to_win = score_to_win
	if SPEED == null:
		SPEED = CONST.SPEED

func _ready():
	HUD.initialize_level(level_name,score_to_win)
	if color_generator_amounts == null: #BugDetected: IntArray can't have a default value
		color_generator_amounts = [1,1,2,2,2,3,3,3,3,4,4,5,6]
	for node in get_children():
		if node extends Path2D:
			assert(node.get_pos()==Vector2(0,0))
			assert(node.get_rot()==0)
			var curve = LevelPath.new()
			curve.curve = node.get_curve()
			curve.color_generator_amounts = color_generator_amounts
			curve.colors = colors
			paths.append(curve)
		elif node extends preload("res://systems/player/player.gd"):
			pass
	set_fixed_process(true)
	set_process_input(true)
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.2)
	add_child(timer)
	
	#Ignore input at the start:
	GameManager.ignore_input = true
	
	#Wait timer
	wait_timer = Timer.new()
	wait_timer.set_autostart(true)
	wait_timer.set_one_shot(true)
	wait_timer.set_wait_time(wait_time)
	add_child(wait_timer)
	wait_timer.connect("timeout",self,"on_wait_timer_timeout")
	
	
	#timer for counting playtime:
	player_timer = Timer.new()
	player_timer.set_autostart(true)
	player_timer.set_wait_time(1.0)
	add_child(player_timer)
	player_timer.start()
	player_timer.connect("timeout",self,"_on_player_timer_timeout")


func restart():
	for path in paths:
		path.cleared=false
	GameManager.level_score = 0
	HUD.initialize_level(level_name,score_to_win)
	HUD.score_label.set_text(str(GameManager.level_score))
	direction=CONST.DIR_FORWARD
	state=CONST.STATE_PLAYING
	set_fixed_process(true)
	set_process_input(true)
	Globals.get("player").set_process_input(true)
	GameManager.time = {"hours":0,"minutes":0,"seconds":0}
	has_waited = false
	wait_timer.set_wait_time(wait_time)
	wait_timer.start()
	GameManager.ignore_input = true

#region updaters
func _input(ev):
	if ev.type == InputEvent.KEY && ev.scancode==KEY_ESCAPE && ev.pressed:
		PAUSE_MENU.pause()
	if (CONST.DEBUG):
		if ev.type == InputEvent.KEY && ev.scancode==KEY_SPACE && ev.pressed:
			if direction == CONST.DIR_FORWARD:
				direction = CONST.DIR_BACKWARD
			else:
				direction = CONST.DIR_FORWARD
		if ev.type == InputEvent.KEY && ev.scancode==KEY_O && ev.pressed:
			GameManager.game_over()
		if ev.type == InputEvent.KEY && ev.scancode==KEY_S && ev.pressed:
			GameManager.add_score(100)
		if ev.type == InputEvent.KEY && ev.scancode==KEY_SHIFT && ev.pressed:
			time_scale=5
		if ev.type == InputEvent.KEY && ev.scancode==KEY_SHIFT && !ev.pressed:
			time_scale=1
		if ev.type == InputEvent.KEY && ev.scancode==KEY_P && ev.pressed:
			print("Bals types exist on the playfield: ",GameManager.balls_type)
		if ev.type == InputEvent.KEY && ev.scancode==KEY_L && ev.pressed:
			GameManager.on_lose()

func _fixed_process(delta):
	delta*=time_scale
	# Handles the wait time
	if wait_time > 0 and not has_waited:
		time_scale = 10
	if state in [CONST.STATE_PLAYING,CONST.STATE_SCORED]:
		# Code to detect ball types will only start when score is greater than score_to_win
		
		for path in paths:
			if path.cleared:
				continue
			var curve = path.curve
			if direction == CONST.DIR_FORWARD:
				if state==CONST.STATE_PLAYING && path.first_ball == null:
					path.first_ball = create_ball(path,null,null)
					path.last_ball = path.first_ball
					path.balls.append(path.first_ball)
				if state==CONST.STATE_PLAYING && path.first_ball.offset >= CONST.MIN_SEPARATION:
					path.first_ball = create_ball(path,null,path.first_ball)
					path.balls.append(path.first_ball)
				if path.first_ball != null:
					path.first_ball.offset+=delta*SPEED
			elif direction == CONST.DIR_BACKWARD:
				if (path.last_ball == null):
					return
				path.last_ball.offset-=delta*SPEED
			if path.last_ball!=null:
				path.cleared_pos = path.last_ball.offset
			if  path.balls.size()==0 && state==CONST.STATE_SCORED:
				path.cleared=true
			if path.last_ball!=null&&path.last_ball.offset>=path.curve.get_baked_length():
				state = CONST.STATE_LOSE
				Globals.get("player").set_process_input(false)
		var win = true
		for path in paths:
			if !path.cleared:
				win=false
				break
		if win:
			GameManager.ignore_input = true
			set_fixed_process(false)
			var t = Timer.new()
			add_child(t)
			t.set_wait_time(0.1)
			t.set_one_shot(false)
			t.start()
			for path in paths:
				while path.cleared_pos < path.curve.get_baked_length():
					var pos = path.curve.interpolate_baked(path.cleared_pos)
					var l = score_label_scn.instance()
					l.setup(100)
					l.set_color(Color(0.992188,0.982377,0.364319))
					l.set_pos(pos)
					add_child(l)
					var e = explosion_scn.instance()
					e.set_pos(pos)
					add_child(e)
					GameManager.add_score(100)
					yield(t,"timeout")
					path.cleared_pos+=CONST.MIN_SEPARATION
			t.set_wait_time(1)
			HUD.show()
			t.start()
			yield(t,"timeout")
			
			GameManager.advance_level()
	if state == CONST.STATE_LOSE:
		for path in paths:
			if path.cleared:
				continue
			if path.first_ball != null:
				path.first_ball.offset+=delta*SPEED*10
				if path.last_ball!=null&&path.last_ball.offset>=path.curve.get_baked_length():
					path.last_ball.dispose()
				if path.first_ball == null:
					path.cleared=true
		var lose = true
		for path in paths:
			if !path.cleared:
				lose=false
				break
		if lose:
			set_fixed_process(false)
			var t = Timer.new()
			add_child(t)
			t.set_wait_time(5)
			t.start()
			yield(t,"timeout")
			GameManager.on_lose()

#region functions
func create_ball(path,prev_ball,next_ball):
	
	var ball = ball_scn.instance()
	ball.path = path
	ball.color = path.get_next_color()
	call_deferred("add_child",ball)
	if prev_ball != null:
		prev_ball.next_ball = ball
		ball.previous_ball = next_ball
	if next_ball != null:
		next_ball.previous_ball = ball
		ball.next_ball = next_ball
	return ball

func on_ball_inserted(ball,path):
	var is_shoot = ball.inserting
	var score_pos = ball.get_pos()
	var c = ball.color
	while (ball.previous_ball != null && ball.previous_ball.color==c):
		ball = ball.previous_ball #get the first ball of the same color
	var balls = []
	while (ball!=null && ball.color == c):
		balls.append(ball)
		ball = ball.next_ball
	var pullable_ball = balls[balls.size()-1].next_ball
	if (balls.size() >= 3):
		for b in balls:
			b.dispose(true)
		if pullable_ball != null:
			pullable_ball.pulling=true
		set_fixed_process(false)
		timer.start()
		if is_shoot:
			chain_bonus+=1
		var score = balls.size()*CONST.SCORE_PER_BALL
		if chain_bonus >= CONST.CHAINS_FOR_BONUS:
			score *= chain_bonus
		GameManager.add_score(score)
		var label = score_label_scn.instance()
		label.setup(score,chain_bonus)
		label.set_pos(score_pos)
		add_child(label)
		yield(timer,"timeout")
		set_fixed_process(true)
	else:
		if is_shoot:
			chain_bonus = 0


func _on_player_timer_timeout():
	GameManager.time["seconds"]+=1
	pass
func on_wait_timer_timeout():
	has_waited = true
	GameManager.time["seconds"]=0
	time_scale = 1
	GameManager.ignore_input = false
	