tool

extends Node

#region DEBUG
const DEBUG = true

#region enum
const DIR_FORWARD = 0
const DIR_BACKWARD = 1

const STATE_PLAYING = 0
const STATE_LOSE = 1
const STATE_WIN = 2

#region constants
const SPEED = 100
const MIN_SEPARATION = 64
const SHOOT_SPEED = 200
const FAST_SHOOT_SPEED = 250
const SHOOT_DISTANCE = 64

const COLOR_RED = 0
const COLOR_GREEN = 1
const COLOR_BLUE = 2
const COLOR_YELLOW = 3

const colors = [
Color(0.9375,0.102539,0.239525),
Color(0.069916,0.617188,0.091294),
Color(0.247162,0.439194,0.710938),
Color(0.949219,0.885547,0.367081)
]