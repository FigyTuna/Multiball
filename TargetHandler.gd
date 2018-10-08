extends Spatial

var Target = preload("res://Scenes/Target.tscn")

export var radius = 7
export var spacing = 15
export var row_spacing = 3

signal all_down()

func _ready():
	var target
	var mirror
	for row in range(3):
		target = Target.instance()
		target.translation.z = -radius + (row * row_spacing)
		if not row == 1:
			target.start_down()
			target.keep_down = true
		add_child(target)
		target.connect("score", self, "_on_target_score")
		for i in range(1, 5):
			target = Target.instance()
			mirror = Target.instance()
			
			target.translation = Vector3(sin(deg2rad(i*spacing)) * radius, 0, -cos(deg2rad(i*spacing)) * radius + (row * row_spacing))
			mirror.translation = Vector3(-sin(deg2rad(i*spacing)) * radius, 0, -cos(deg2rad(i*spacing)) * radius + (row * row_spacing))
			
			target.rotation.y = -sin(deg2rad(i*spacing))
			mirror.rotation.y = sin(deg2rad(i*spacing))
			
			if not (row == 1 and (i == 2 or i == 4)):
				target.start_down()
				mirror.start_down()
				target.keep_down = true
				mirror.keep_down = true
			
			add_child(target)
			add_child(mirror)
			target.connect("score", self, "_on_target_score")
			mirror.connect("score", self, "_on_target_score")

func bring_all_up():
	for child in get_children():
		child.bring_up()

func attach_all(main):
	for child in get_children():
		child.connect("score", main, "_on_target_score")

func put_all_down():
	for child in get_children():
		if child.keep_down:
			child.go_down = true
			child.stay_down = true
			child.timer = 3

func _on_target_score():
	var all_down = true
	for child in get_children():
		if not child.go_down:
			all_down = false
	if all_down:
		emit_signal("all_down")