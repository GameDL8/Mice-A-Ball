
extends Node2D

class LevelPath:
	var curve
	var balls = []
	var first_ball
	var last_ball

export(NodePath) var path1
export(NodePath) var path2
export(NodePath) var path3
export(PackedScene) var ball_scn
export(int,FLAGS,"Red,Green,Blue,Yellow") var colors = 7

var paths = []
var direction = CONST.DIR_FORWARD

func _init():
	randomize()
	

func _ready():
	if (path1 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path1).get_curve()
		curve.first_ball = create_ball(null,null)
		curve.balls.append(curve.first_ball)
		paths.append(curve)
	if (path2 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path2).get_curve()
		curve.first_ball = create_ball(null,null)
		paths.append(curve)
	if (path3 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path3).get_curve()
		curve.first_ball = create_ball(null,null)
		paths.append(curve)
	
	set_fixed_process(true)
	

func _fixed_process(delta):
	for path in paths:
		if direction == CONST.DIR_FORWARD:
			var curve = path.curve
			if path.first_ball.offset >= CONST.MIN_SEPARATION:
				path.first_ball = create_ball(null,path.first_ball)
				path.first_ball.offset = path.first_ball.next_ball.offset-CONST.MIN_SEPARATION
				path.balls.append(path.first_ball)
			path.first_ball.offset+=delta*CONST.SPEED
			for ball in path.balls:
				ball.set_pos(curve.interpolate_baked(ball.offset))

func create_ball(prev_ball,next_ball):
	var col = []
	for c in range(4):
		if (colors|c):
			col.append(c)
	var ball = ball_scn.instance()
	get_tree().get_root().call_deferred("add_child",ball)
	if prev_ball != null:
		prev_ball.next_ball = ball
		ball.previous_ball = next_ball
	if next_ball != null:
		next_ball.previous_ball = ball
		ball.next_ball = next_ball
	ball.color = col[rand_range(0,col.size())]
	return ball
