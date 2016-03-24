
extends Node2D

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

#region variables
export(String) var level_name = "KITCHEN"
export(int) var score_to_win = 1000
export(int,FLAGS,"Red,Green,Blue,Yellow") var colors = 7
export(IntArray) var color_generator_amounts = [1,1,2,2,2,3,3,3,3,4,4,5,6] #BugDetected: IntArray can't have a default value

var state = CONST.STATE_PLAYING
var chain_bonus = 0
var paths = []
var direction = CONST.DIR_FORWARD
var timer

#region constructors
func _init():
	randomize()
	Globals.set("current_level", self)

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
		if ev.type == InputEvent.KEY && ev.scancode==KEY_SHIFT && ev.pressed:
			GameManager.game_over()

func _fixed_process(delta):
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
				path.first_ball.offset+=delta*CONST.SPEED
		elif direction == CONST.DIR_BACKWARD:
			if (path.last_ball == null):
				return
			path.last_ball.offset-=delta*CONST.SPEED
		if  path.balls.size()==0 && state==CONST.STATE_SCORED:
			path.cleared=true
	var win = true
	for path in paths:
		if !path.cleared:
			win=false
			break
	if win:
		print("FINISHED THE LEVEL!")
		set_fixed_process(false)


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
