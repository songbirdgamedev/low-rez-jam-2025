extends CanvasLayer


@onready var fish_s: Sprite2D = %FishS
@onready var fish_m: Sprite2D = %FishM
@onready var fish_l: Sprite2D = %FishL
@onready var fish_xl: Sprite2D = %FishXL

@onready var label_s: Label = %LabelS
@onready var label_m: Label = %LabelM
@onready var label_l: Label = %LabelL
@onready var label_xl: Label = %LabelXL

@onready var page_number: Label = %PageNumber
@onready var left_arrow: TextureRect = %LeftArrow
@onready var right_arrow: TextureRect = %RightArrow

const NUM_COLOURS: int = 8
const NUM_SIZES: int = 4
const SHEET_HEIGHT: int = Fish.SPRITE_SIZE * NUM_SIZES

var sprites: Array[Sprite2D]
var labels: Array[Label]
var all_fish: Array[Array] = []
var current_page: int = 0


func _ready() -> void:
	hide()
	sprites = [fish_s, fish_m, fish_l, fish_xl]
	labels = [label_s, label_m, label_l, label_xl]

	all_fish.resize(NUM_COLOURS)

	for page in all_fish:
		page.resize(NUM_SIZES)

		for i in page.size():
			page[i] = {
				"caught": false,
				"region": _get_default_region(i),
				"biggest": 0.0
			}

		_set_sprite_regions(page)


func _process(_delta: float) -> void:
	if not is_visible():
		return

	elif Input.is_action_just_pressed("left") and current_page > 0:
		current_page -= 1
		AudioManager.play_turn_page()
		_show_page(all_fish[current_page])
	elif Input.is_action_just_pressed("right") and current_page < 7:
		current_page += 1
		AudioManager.play_turn_page()
		_show_page(all_fish[current_page])


func add_fish(new: Fish) -> String:
	var message: String = ""

	if not all_fish[new.colour][new.size_category].caught:
		all_fish[new.colour][new.size_category].caught = true
		all_fish[new.colour][new.size_category].region = new.sprite_region
		message = "new fish!"

	if all_fish[new.colour][new.size_category].biggest < new.size_inches:
		all_fish[new.colour][new.size_category].biggest = new.size_inches
		if message == "":
			message = "size record!"

	return message


func show_log() -> void:
	_show_page(all_fish[current_page])


func _show_page(page: Array) -> void:
	_set_sprite_regions(page)
	_set_labels(page)
	_set_page_number()
	_set_arrow_visibility()

	if not is_visible():
		show()


func _get_default_region(index: Fish.Size) -> Rect2i:
	var rect_y_position: int = index * Fish.SPRITE_SIZE + SHEET_HEIGHT
	return Rect2i(0, rect_y_position, Fish.SPRITE_SIZE, Fish.SPRITE_SIZE)


func _set_sprite_regions(page: Array) -> void:
	for i in sprites.size():
		sprites[i].set_region_rect(page[i].region)


func _set_labels(page: Array) -> void:
	for i in labels.size():
		if page[i].biggest > 0:
			labels[i].text = str(page[i].biggest)
		else:
			labels[i].text = ""


func _set_page_number() -> void:
	page_number.text = str(current_page + 1)


func _set_arrow_visibility() -> void:
	left_arrow.show()
	right_arrow.show()

	if current_page == 0:
		left_arrow.hide()
	elif current_page == 7:
		right_arrow.hide()
