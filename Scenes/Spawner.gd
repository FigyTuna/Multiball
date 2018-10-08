extends Spatial

var Ball = preload("res://Scenes/Ball.tscn")

export(NodePath) var board_path
export var right = false

onready var board = get_node(board_path)
onready var main = get_parent()

var queued = 0
var timer = 0

func _physics_process(delta):
	timer -= delta
	if timer <= 0 and queued > 0:
		spawn()
		queued -= 1
		timer = 0.01 + rand_range(0, .08)

func spawn():
	var ball = Ball.instance()
	ball.board = board
	ball.connect("bump", main, "_on_ball_bump")
	ball.connect("die", main, "_on_ball_die")
	add_child(ball)
	var multiply = 1
	if right:
		multiply = -1
	ball.apply_impulse(Vector3(1, -1 * multiply, 1), Vector3(-25 * multiply, 30, -60) + Vector3(rand_range(0, 3), rand_range(0, 3), rand_range(0, 3)))

func queue_spawn(var num):
	queued += num