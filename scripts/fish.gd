class_name Fish
extends Node2D


@onready var sprite: Sprite2D = $Sprite

const SPRITE_SIZE: int = 16
const RECT_SIZE: Vector2i = Vector2i(SPRITE_SIZE, SPRITE_SIZE)

var rect_position: Vector2i
var sprite_region: Rect2i
var size_inches: float

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


func _init(colour: Colour, size: Size, inches: float) -> void:
	rect_position = Vector2i(colour * SPRITE_SIZE, size * SPRITE_SIZE)
	sprite_region = Rect2i(rect_position, RECT_SIZE)
	size_inches = inches


func _ready() -> void:
	sprite.set_region_rect(sprite_region)
