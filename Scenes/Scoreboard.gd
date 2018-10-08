extends Spatial

var d = []

func _ready():
	d.append(preload("res://Images/numbers/0.png"))
	d.append(preload("res://Images/numbers/1.png"))
	d.append(preload("res://Images/numbers/2.png"))
	d.append(preload("res://Images/numbers/3.png"))
	d.append(preload("res://Images/numbers/4.png"))
	d.append(preload("res://Images/numbers/5.png"))
	d.append(preload("res://Images/numbers/6.png"))
	d.append(preload("res://Images/numbers/7.png"))
	d.append(preload("res://Images/numbers/8.png"))
	d.append(preload("res://Images/numbers/9.png"))

func update_score(score):
	var score_str = ("0000000" + str(score))
	score_str = score_str.substr(len(score_str)-7, 7)
	var i = 0
	for c in score_str:
		get_node("Segment" + str(i)).texture = d[int(c)]
		i += 1