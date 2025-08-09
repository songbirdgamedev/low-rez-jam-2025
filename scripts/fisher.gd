class_name Fisher
extends Fish


@onready var fisher: Fisher = $"."

const MIN_SIZE: float = 1.0
const SIZE_ALLOWANCE: float = 6.0
const PRECISION: float = 0.1

var random_float: float
var random_inches: float
var inches: float

var new_fish: Fish

var current_size: float
var current_state: State

enum State {
	READY,
	WAITING,
	HOOKED,
	CAUGHT
}


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("confirm"):
		return

	match State:
		State.READY:
			_cast_line()
		State.WAITING:
			# check if fish bite first
			_hook_fish()
		State.HOOKED:
			# check if pressed in middle or not
			_catch_fish()


func _cast_line() -> void:
	# play animation
	_change_state(State.WAITING)


func _hook_fish() -> void:
	_change_state(State.HOOKED)
	# start minigame


func _catch_fish() -> void:
	_change_state(State.CAUGHT)

	random_float = randf()
	random_inches = randf_range(MIN_SIZE, current_size + SIZE_ALLOWANCE)
	inches = snappedf(random_inches, PRECISION)
	new_fish = Fish.new(random_float, inches)

	# play animation of fish coming out of water

	if inches > current_size:
		_replace_fisher()

	_change_state(State.READY)


func _miss_fish() -> void:
	# play animation
	_change_state(State.READY)


func _replace_fisher() -> void:
	# play animation
	fisher = new_fish
	# might need to reset the flip_h
	# or maybe just set the sprite region idk


func _change_state(next_state: State) -> void:
	current_state = next_state

	match next_state:
		State.READY:
			print("Changing state to State.READY")
		State.WAITING:
			print("Changing state to State.WAITING")
		State.HOOKED:
			print("Changing state to State.HOOKED")
		State.CAUGHT:
			print("Changing state to State.CAUGHT")
