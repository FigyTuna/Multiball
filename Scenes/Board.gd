extends Spatial

onready var init_left = deg2rad($'LFlipper'.rotation.y)
onready var init_right = deg2rad($'RFlipper'.rotation.y)

const COOLDOWN = 0.2
const FLIPPING_TIME = 0.02
const FLIP_ROTATION = deg2rad(35)
const FLIPPER_SPEED = 9

const FLASH_SPEED = 0.06
const LIGHTNING_SPEED = 0.13

var left_cooldown = 0
var right_cooldown = 0

var left_flipping = 0
var right_flipping = 0

var left_up = false
var right_up = false


var flash_timer = 0
var flash_on = 0
var logo_stay_on = true

var lightning_timer = 0
var lightning_flash_timer = 0

signal flipper_go()

func _input(event):
	if event.is_action_pressed("left"):
		flip_left()
	elif event.is_action_pressed("right"):
		flip_right()

func flip_left():
	if left_cooldown < 0:
		left_up = true
		left_cooldown = COOLDOWN
		left_flipping = FLIPPING_TIME
		emit_signal("flipper_go")

func is_left_flipping():
	return left_flipping > 0

func flip_right():
	if right_cooldown < 0:
		right_up = true
		right_cooldown = COOLDOWN
		right_flipping = FLIPPING_TIME
		emit_signal("flipper_go")

func is_right_flipping():
	return right_flipping > 0

func flash_logo(how_long):
	flash_timer = how_long

func flash_lightning(how_long):
	lightning_timer = how_long

func _physics_process(delta):
	left_cooldown -= delta
	right_cooldown -= delta
	left_flipping -= delta
	right_flipping -= delta
	if left_up and $'LFlipper'.rotation.y < FLIP_ROTATION:
		$'LFlipper'.rotation.y += delta * FLIPPER_SPEED
		if $'LFlipper'.rotation.y >= FLIP_ROTATION:
			left_up = false
	if not left_up and $'LFlipper'.rotation.y > init_left:
		$'LFlipper'.rotation.y -= delta * FLIPPER_SPEED
	if right_up and $'RFlipper'.rotation.y > -FLIP_ROTATION:
		$'RFlipper'.rotation.y -= delta * FLIPPER_SPEED
		if $'RFlipper'.rotation.y <= -FLIP_ROTATION:
			right_up = false
	if not right_up and $'RFlipper'.rotation.y < init_right:
		$'RFlipper'.rotation.y += delta * FLIPPER_SPEED
	
	flash_timer -= delta
	flash_on -= delta
	if flash_timer > 0:
		if flash_on > 0:
			$'LogoOn'.visible = true
		elif flash_on > -FLASH_SPEED:
			$'LogoOn'.visible = false
		else:
			flash_on = FLASH_SPEED
	else:
		$'LogoOn'.visible = logo_stay_on
	
	lightning_timer -= delta
	lightning_flash_timer -= delta
	if lightning_timer > 0:
		if lightning_flash_timer > 0:
			$'LLightning'.visible = true
			$'RLightning'.visible = false
		elif lightning_flash_timer > -LIGHTNING_SPEED:
			$'LLightning'.visible = false
			$'RLightning'.visible = true
		else:
			lightning_flash_timer = LIGHTNING_SPEED
	else:
		$'LLightning'.visible = false
		$'RLightning'.visible = false