
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
#auxiliar
var offset = 0

func _ready():
	if (path1 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path1).get_curve()
		curve.first_ball = get_node("Sprite")
		paths.append(curve)
	if (path2 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path2).get_curve()
		paths.append(curve)
	if (path3 != null):
		var curve = LevelPath.new()
		curve.curve = get_node(path3).get_curve()
		paths.append(curve)
	
	set_fixed_process(true)
	

func _fixed_process(delta):
	for path in paths:
		if direction == CONST.DIR_FORWARD:
			var ball = path.first_ball
			print (ball.get_name())
			var curve = path.curve
			offset+=delta*CONST.SPEED
			ball.set_pos(curve.interpolate_baked(offset))


