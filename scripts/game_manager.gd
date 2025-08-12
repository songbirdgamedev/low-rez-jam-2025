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


signal line_cast
signal fish_hooked
signal fish_missed
signal fish_caught


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
			_attempt_catch()


func _cast_line() -> void:
	print("casting line")
	line_cast.emit()
	_change_state(State.WAITING)


func _hook_fish() -> void:
	print("hooking fish")
	fish_hooked.emit()
	_change_state(State.HOOKED)

	random_float = randf()
	random_inches = randf_range(MIN_SIZE, fisher.size_inches + SIZE_ALLOWANCE)
	inches = snappedf(random_inches, PRECISION)

	new_fish = Fish.new(random_float, inches)
	minigame.start(new_fish.colour)


func _attempt_catch() -> void:
	var result: Minigame.Result = minigame.end()

	match result:
		0:
			_miss_fish()
		1:
			message.show_text("keep going...")
			minigame.start(new_fish.colour)
		2:
			_catch_fish()
		3:
			_catch_fish()


func _catch_fish() -> void:
	print("catching fish")
	fish_caught.emit()
	_change_state(State.CAUGHT)

	fish_log.add_fish(new_fish)

	# play animation of fish coming out of water
	if inches > fisher.size_inches:
		fisher.replace_fisher(new_fish)

	_change_state(State.READY)


func _miss_fish() -> void:
	fish_missed.emit()
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
