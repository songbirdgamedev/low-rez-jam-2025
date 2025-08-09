class_name Fish
extends Node2D


@onready var sprite: Sprite2D = $Sprite

const SPRITE_SIZE: int = 16
const RECT_SIZE: Vector2i = Vector2i(SPRITE_SIZE, SPRITE_SIZE)

var rect_position: Vector2i
var sprite_region: Rect2i

var colour: Colour
var size_inches: float
var size_category: Size

enum Colour {
	LIGHTGREY,
	DARKGREY,
	BLACK,
	BROWN,
	RED,
	GREEN,
	SILVER,
	GOLD
}

enum Size {
	S,
	M,
	L,
	XL
}


func _init(random_float: float = 0.0, inches: float = 3.0) -> void:
	print(random_float, " ", inches)

	colour = _determine_colour(random_float)
	size_inches = inches
	size_category = _determine_size(inches)

	rect_position = Vector2i(colour * SPRITE_SIZE, size_category * SPRITE_SIZE)
	sprite_region = Rect2i(rect_position, RECT_SIZE)


func _ready() -> void:
	sprite.set_region_rect(sprite_region)


func _determine_colour(random_float: float) -> Colour:
	if random_float < 0.2:
		return Colour.LIGHTGREY
	elif random_float < 0.38:
		return Colour.DARKGREY
	elif random_float < 0.56:
		return Colour.BLACK
	elif random_float < 0.7:
		return Colour.BROWN
	elif random_float < 0.8:
		return Colour.RED
	elif random_float < 0.9:
		return Colour.GREEN
	elif random_float < 0.96:
		return Colour.SILVER
	else:
		return Colour.GOLD


func _determine_size(inches: float) -> Size:
	if inches < 10:
		return Size.S
	elif inches < 20:
		return Size.M
	elif inches < 30:
		return Size.L
	else:
		return Size.XL
