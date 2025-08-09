extends CanvasLayer


var all_fish: Array[Array] = []


func _ready() -> void:
	hide()

	all_fish.resize(8)
	for row in all_fish:
		row.resize(4)
		for i in row.size():
			row[i] = {"caught": false, "biggest": 0.0}


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if is_visible():
			hide()
		else:
			show()


func add_fish(new: Fish) -> void:
	if not all_fish[new.colour][new.size_category].caught:
		all_fish[new.colour][new.size_category].caught = true
		print("new fish")

	if all_fish[new.colour][new.size_category].biggest < new.size_inches:
		all_fish[new.colour][new.size_category].biggest = new.size_inches
		print("new size record")

	print(all_fish)
