extends Node


@onready var fisher: Fisher = %Fisher
@onready var bobber: AnimatedSprite2D = %Bobber
@onready var minigame: CanvasLayer = %Minigame
@onready var message: CanvasLayer = %Message
@onready var fish_log: CanvasLayer = %FishLog


const MIN_SIZE: float = 1.0
const SIZE_ALLOWANCE: float = 6.0
const PRECISION: float = 0.1

var random_float: float
var random_inches: float
var inches: float
var new_fish: Fish
var current_state: State = State.READY

enum State {
	READY,
	WAITING,
	HOOKED,
	CAUGHT
}


func _ready() -> void:
	bobber.bite_missed.connect(_miss_fish)


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

	random_float = randf()
	random_inches = randf_range(MIN_SIZE, fisher.size_inches + SIZE_ALLOWANCE)
	inches = snappedf(random_inches, PRECISION)

	new_fish = Fish.new(random_float, inches)
	bobber.hook_fish()
	minigame.start(new_fish.colour)


func _catch_fish() -> void:
	print("catching fish")
	_change_state(State.CAUGHT)

	fish_log.add_fish(new_fish)

	# play animation of fish coming out of water
	bobber.hide_bobber()
	if inches > fisher.size_inches:
		fisher.replace_fisher(new_fish)

	_change_state(State.READY)


func _miss_fish() -> void:
	# play animation
	message.show_text("it got away...")
	_change_state(State.READY)


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
