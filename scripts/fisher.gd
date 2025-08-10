class_name Fisher
extends Fish


@onready var fisher: Fisher = %Fisher
@onready var bobber: AnimatedSprite2D = %Bobber
@onready var fish_log: CanvasLayer = %FishLog

const MIN_SIZE: float = 1.0
const SIZE_ALLOWANCE: float = 6.0
const PRECISION: float = 0.1

var current_state: State = State.READY

enum State {
	READY,
	WAITING,
	HOOKED,
	CAUGHT
}


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("confirm"):
		return

	match current_state:
		State.READY:
			_cast_line()
		State.WAITING:
			# check if fish bite first
			_hook_fish()
		State.HOOKED:
			# check if pressed in middle or not
			_catch_fish()


func _cast_line() -> void:
	print("casting line")
	# play animation
	bobber.show_bobber()
	_change_state(State.WAITING)


func _hook_fish() -> void:
	print("hooking fish")
	_change_state(State.HOOKED)
	# start minigame


func _catch_fish() -> void:
	print("catching fish")
	_change_state(State.CAUGHT)

	var random_float: float = randf()
	var random_inches: float = randf_range(MIN_SIZE, size_inches + SIZE_ALLOWANCE)
	var inches: float = snappedf(random_inches, PRECISION)

	var new_fish = Fish.new(random_float, inches)
	fish_log.add_fish(new_fish)

	# play animation of fish coming out of water
	bobber.hide_bobber()
	if inches > size_inches:
		_replace_fisher(new_fish)

	_change_state(State.READY)


func _miss_fish() -> void:
	# play animation
	bobber.hide_bobber()
	_change_state(State.READY)


func _replace_fisher(new_fish: Fish) -> void:
	print("replacing fisher")
	# play animation

	colour = new_fish.colour
	size_inches = new_fish.size_inches
	size_category = new_fish.size_category
	rect_position = new_fish.rect_position
	sprite_region = new_fish.sprite_region
	sprite.set_region_rect(sprite_region)


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
