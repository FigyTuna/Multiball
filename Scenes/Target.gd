extends Spatial

const SPEED = 2

var initial = 0
var down = -2

var go_down = false
var stay_down = false
var keep_down = false

var timer = 0

signal score()

func start_down():
	stay_down = true
	translation.y = down

func bring_up():
	if stay_down or go_down:
		stay_down = false
		go_down = true
		timer = rand_range(0, 3)

func trigger():
	if not go_down:
		go_down = true
		timer = 12 + rand_range(0, 4)
		emit_signal("score")

func _physics_process(delta):
	if go_down and translation.y > down:
		translation.y -= delta * SPEED * 4
	elif not go_down and translation.y < initial and not stay_down:
		translation.y += delta * SPEED
	
	timer -= delta
	if go_down and timer < 0:
		go_down = false
