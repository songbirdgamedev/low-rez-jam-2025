extends CanvasLayer


@onready var fish_s: Sprite2D = %FishS
@onready var fish_m: Sprite2D = %FishM
@onready var fish_l: Sprite2D = %FishL
@onready var fish_xl: Sprite2D = %FishXL

@onready var label_s: Label = %LabelS
@onready var label_m: Label = %LabelM
@onready var label_l: Label = %LabelL
@onready var label_xl: Label = %LabelXL

var all_fish: Array[Array] = []


func _ready() -> void:
	hide()

	all_fish.resize(8)
	for page in all_fish:
		page.resize(4)
		for i in page.size():
			page[i] = {"caught": false, "biggest": 0.0}


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
