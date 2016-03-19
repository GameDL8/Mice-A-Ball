
extends Node2D

var ball_scn=preload("res://systems/ball/ball.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
	pass
	
func _fixed_process(delta):
	look_at(get_node("/root").get_mouse_pos())

func shoot():
	var mpos = get_node("/root").get_mouse_pos()
	var dir = (mpos-get_pos()).normalized()
	var ball = ball_scn.instance()
	
	get_tree().get_root().call_deferred("add_child",ball)
	