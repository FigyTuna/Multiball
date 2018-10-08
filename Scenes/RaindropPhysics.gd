extends Area

onready var light = $'../OmniLight'

var timer = 0
var light_on = false

signal score()

func _on_body_entered(body):
	if body is RigidBody:
		light.omni_attenuation = 0.1
		timer = 0.08
		light_on = true
		emit_signal("score")

func _physics_process(delta):
	timer -= delta
	if timer < 0 and light_on:
		light_on = false
		light.omni_attenuation = 1