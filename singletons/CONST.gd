tool

extends Node

#region DEBUG
const DEBUG = true

#region enum
const DIR_FORWARD = 0
const DIR_BACKWARD = 1

const STATE_PLAYING = 0
const STATE_SCORED = 1
const STATE_LOSE = 2
const STATE_WIN = 3

const COLOR_RED = 0
const COLOR_GREEN = 1
const COLOR_BLUE = 2
const COLOR_YELLOW = 3

#region constants
const SPEED = 80
const MIN_SEPARATION = 40
const SHOOT_SPEED = 450
const FAST_SHOOT_SPEED = 650
const SHOOT_DISTANCE = 50
const SCORE_PER_BALL = 10
const CHAINS_FOR_BONUS = 5

const colors = [
preload("res://systems/ball/mice_a.png"),
preload("res://systems/ball/mice_b.png"),
preload("res://systems/ball/mice_c.png"),
preload("res://systems/ball/mice_d.png")
]

var SFX = true
var MUSIC = true