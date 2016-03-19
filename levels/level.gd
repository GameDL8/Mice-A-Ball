
extends Node2D

class LevelPath:
	var curve
	var balls = []
	var first_ball
	var last_ball

export(PackedScene) var ball_scn
export(int,FLAGS,"Red,Green,Blue,Yellow") var colors = 7
export(IntArray) var color_generator_amounts = [1,1,2,2,2,3,3,3,3,4,4,5,6] #BugDetected: IntArray can't have a default value

var state = CONST.STATE_PLAYING
var paths = []
var direction = CONST.DIR_FORWARD
var gen_ball_count = -1
var next_color = -1

func _init():
	randomize()
	

func _ready():
	if color_generator_amounts == null: #BugDetected: IntArray can't have a default value
		color_generator_amounts = [1,1,2,2,2,3,3,3,3,4,4,5,6]
	for node in get_children():
		if node extends Path2D:
			assert(node.get_pos()==Vector2(0,0))
			assert(node.get_rot()==0)
			var curve = LevelPath.new()
			curve.curve = node.get_curve()
			paths.append(curve)
	set_fixed_process(true)
	set_process_input(true)

func _input(ev):
	if (CONST.DEBUG):
		if ev.type == InputEvent.KEY && ev.scancode==KEY_SPACE && ev.pressed:
			if direction == CONST.DIR_FORWARD:
				direction = CONST.DIR_BACKWARD
			else:
				direction = CONST.DIR_FORWARD

func _fixed_process(delta):
	var count = 0
	for path in paths:
		print (str(count))
		count+=1
		var curve = path.curve
		if direction == CONST.DIR_FORWARD:
			if path.first_ball == null:
				path.first_ball = create_ball(null,null)
				path.last_ball = path.first_ball
				path.balls.append(path.first_ball)
			if path.first_ball.offset >= CONST.MIN_SEPARATION:
				path.first_ball = create_ball(null,path.first_ball)
				path.first_ball.offset = path.first_ball.next_ball.offset-CONST.MIN_SEPARATION
				path.balls.append(path.first_ball)
			path.first_ball.offset+=delta*CONST.SPEED
			for ball in path.balls:
				ball.set_pos(curve.interpolate_baked(ball.offset))
		elif direction == CONST.DIR_BACKWARD:
			if (path.last_ball == null):
				return
			path.last_ball.offset-=delta*CONST.SPEED
			for ball in path.balls:
				ball.set_pos(curve.interpolate_baked(ball.offset))

func create_ball(prev_ball,next_ball):
	var ball = ball_scn.instance()
	ball.color = get_next_color()
	ball.connect("disposed", self, "dispose_ball")
	get_tree().get_root().call_deferred("add_child",ball)
	if prev_ball != null:
		prev_ball.next_ball = ball
		ball.previous_ball = next_ball
	if next_ball != null:
		next_ball.previous_ball = ball
		ball.next_ball = next_ball
	return ball

func dispose_ball(ball):
	for path in paths:
		if ball in path.balls:
			path.first_ball = ball.next_ball
			path.balls.remove(path.balls.find(ball))

func get_next_color():
	if gen_ball_count <= 0:
		gen_ball_count = color_generator_amounts[floor(rand_range(0,color_generator_amounts.size()))]
		var new_color = next_color
		while new_color == next_color: #make sure the color changes
			var col = []
			for c in range(1,5):
				if (colors&c):
					col.append(c-1)
			new_color = col[rand_range(0,col.size())]
		next_color=new_color
	gen_ball_count-=1
	return next_color