class_name UI
extends CanvasLayer


@onready var score_label: Label = %Score


var score: int = 0:
	set(v):
		score = v
		_update_score_label()


func _ready() -> void:
	_update_score_label()


func _update_score_label():
	score_label.text = str(score)
