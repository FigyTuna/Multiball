extends Spatial

const RANGE = 35

func _ready():
	for child in get_children():
		child.translation = Vector3(rand_range(-RANGE, RANGE), rand_range(-RANGE, RANGE), 0)

func _physics_process(delta):
	rotation.z += delta