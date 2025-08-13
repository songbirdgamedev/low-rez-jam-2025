class_name Fisher
extends Fish


const MIN_SIZE: float = 1.0
const SIZE_ALLOWANCE: float = 6.0
const PRECISION: float = 0.1


func hook_fish() -> Fish:
	var random_float: float = randf()
	var random_inches: float = randf_range(MIN_SIZE, size_inches + SIZE_ALLOWANCE)
	var inches: float = snappedf(random_inches, PRECISION)

	return Fish.new(random_float, inches)


func check_size(new_fish: Fish) -> void:
	if new_fish.size_inches > size_inches:
		_replace_fisher(new_fish)


func _replace_fisher(new_fish: Fish) -> void:
	# play animation

	colour = new_fish.colour
	size_inches = new_fish.size_inches
	size_category = new_fish.size_category
	rect_position = new_fish.rect_position
	sprite_region = new_fish.sprite_region

	sprite.set_region_rect(sprite_region)
