extends Node


const MIN_SIZE: float = 1.0
const SIZE_ALLOWANCE: float = 6.0
const PRECISION: float = 0.1

var current_size: float

var random_float: float
var random_inches: float
var inches: float

var new_fish: Fish


func _catch_fish() -> void:
	random_float = randf()
	random_inches = randf_range(MIN_SIZE, current_size + SIZE_ALLOWANCE)
	inches = snappedf(random_inches, PRECISION)
	new_fish = Fish.new(random_float, random_inches)
