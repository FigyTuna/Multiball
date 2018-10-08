extends RigidBody

const FLIPPER_FORCE = 110
const BUMPER_FORCE = 100

var board

signal bump()
signal die()

func _physics_process(delta):
	if linear_velocity.y < -15:
		emit_signal("die")
		queue_free()
	for body in get_colliding_bodies():
		if body.name == "BumperPhysics":
			shoot(body.get_parent().translation, BUMPER_FORCE * delta)
			emit_signal("bump")
		elif body.name.find("LeftFlipper") != -1 and board.is_left_flipping():
			shoot(Vector3(0, 0, 40), FLIPPER_FORCE * delta)
		elif body.name.find("RightFlipper") != -1 and board.is_right_flipping():
			shoot(Vector3(0, 0, 40), FLIPPER_FORCE * delta)
		elif body.name == "TargetPhysics":
			body.trigger()

func shoot(pos, force):
	apply_impulse(pos, (-pos - translation - get_parent().translation) * force)