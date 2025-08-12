class_name Fisher
extends Fish


func replace_fisher(new_fish: Fish) -> void:
	print("replacing fisher")
	# play animation

	colour = new_fish.colour
	size_inches = new_fish.size_inches
	size_category = new_fish.size_category
	rect_position = new_fish.rect_position
	sprite_region = new_fish.sprite_region
	sprite.set_region_rect(sprite_region)
