extends CanvasLayer


@onready var label: Label = $Label

var score: int = 0


func _ready() -> void:
	label.text = str(score)


func update_score(new_fish: Fish, perfect: bool) -> void:
	var score_to_add: int = 0

	match new_fish.colour:
		0:
			score_to_add += 10
		1, 2:
			score_to_add += 12
		3:
			score_to_add += 14
		4, 5:
			score_to_add += 16
		6:
			score_to_add += 18
		7:
			score_to_add += 20

	match new_fish.size_category:
		1:
			score_to_add += 2
		2:
			score_to_add += 5
		3:
			score_to_add += 10

	if perfect:
		score_to_add *= 2

	score += score_to_add
	label.text = str(score)
