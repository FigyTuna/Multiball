extends Spatial

signal score()

func _on_score():
	emit_signal("score")
