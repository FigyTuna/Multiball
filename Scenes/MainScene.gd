extends Spatial

enum STATES {title, game, game_transition}

var game_state = STATES.title

var score = 0
var first_multiball = true

var bell_sound_timer = 0
var lights_timer = 0

var strip_timer = 0
var strip_fast_timer = 0

func _ready():
	randomize()
	$'TargetHandler'.attach_all(self)

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		var newEvent = InputEventAction.new()
		newEvent.pressed = true
		if event.position.x < get_viewport().get_visible_rect().size.x / 2:
			newEvent.action = "left"
		else:
			newEvent.action = "right"
		Input.parse_input_event(newEvent)
	if game_state == STATES.title and event.is_pressed():
		game_state = STATES.game
		start_game()

func start_game():
	$'Spawner'.queue_spawn(1)
	$'Spawner2'.queue_spawn(2)
	$'Board'.flash_logo(1.5)
	$'AnimationPlayer'.play("start")
	$'Board'.logo_stay_on = false

func _on_animation_finished(anim_name):
	if game_state == STATES.game_transition:
		game_state = STATES.title

func _on_target_score():
	score += 250
	update_score()
	$'TargetSound'.play()
	if first_multiball:
		first_multiball = false
		multiball(50)

func multiball(to_queue_each):
	score += 5000
	update_score()
	$'TargetHandler'.bring_all_up()
	$'Spawner'.queue_spawn(to_queue_each)
	$'Spawner2'.queue_spawn(to_queue_each)
	$'Board'.flash_logo(4)
	$'Board'.flash_lightning(4)
	bell_sound_timer = 3
	lights_timer = 4
	strip_fast_timer = 4
	strip_timer = 0
	for i in range(5):
		get_node("OmniLight" + str(i + 1)).visible = true

func _on_raindrop_score():
	score += 50
	update_score()

func update_score():
	$'Scoreboard'.update_score(score)

func _physics_process(delta):
	bell_sound_timer -= delta
	if bell_sound_timer > 0 and not $'Bell3'.playing:
		$'Bell1'.play(rand_range(0, .1))
		$'Bell2'.play(rand_range(0, .4))
		$'Bell3'.play(rand_range(.5, .7))
	
	lights_timer -= delta
	if lights_timer > 0:
		$'Lights'.rotation += Vector3(rand_range(0, 1), rand_range(1, 2), rand_range(-1, 1)) * delta * 15
		
		for i in range(5):
			get_node("OmniLight" + str(i + 1)).translation = get_node("Lights/LightPos" + str(i + 1)).to_local(Vector3())
	elif get_node("Lights/LightPos1").visible:
		for i in range(5):
			get_node("OmniLight" + str(i + 1)).visible = false
	
	strip_timer -= delta
	strip_fast_timer -= delta
	if strip_timer < 0:
		$'Strip'.visible = !$'Strip'.visible
		$'Strip2'.visible = !$'Strip2'.visible
		strip_timer = 1
		if strip_fast_timer > 0:
			strip_timer = 0.2

func _on_all_targets_down():
	multiball(25)

func _on_flipper_go():
	$'FlipperSound'.play()

func _on_ball_bump():
	$'BumperSound'.play()

func _on_ball_die():
	var ball_count = 0
	for child in $'Spawner'.get_children():
		ball_count += 1
	for child in $'Spawner2'.get_children():
		ball_count += 1
	if ball_count < 2:
		score = 0
		update_score()
		first_multiball = true
		$'SadSound'.play()
		$'Spawner'.queue_spawn(2)
		$'Spawner2'.queue_spawn(1)
		$'TargetHandler'.bring_all_up()
		$'TargetHandler'.put_all_down()

func _on_DeadZone_entered(body):
	if body is RigidBody:
		body.queue_free()