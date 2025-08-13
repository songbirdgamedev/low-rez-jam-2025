class_name Game
extends Node2D


@onready var fisher: Fisher = %Fisher
@onready var bobber: AnimatedSprite2D = %Bobber
@onready var minigame: CanvasLayer = %Minigame
@onready var message: CanvasLayer = %Message
@onready var fish_log: CanvasLayer = %FishLog

var current_state: State = State.READY
var new_fish: Fish

enum State {
	READY,
	WAITING,
	BITE,
	HOOKED
}


func _ready() -> void:
	bobber.cast_timer.timeout.connect(_on_cast_timer_timeout)
	bobber.bite_timer.timeout.connect(_on_bite_timer_timeout)


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("confirm"):
		return

	match current_state:
		State.READY:
			_cast_line()
		State.WAITING:
			_miss_cast()
		State.BITE:
			_hook_fish()
		State.HOOKED:
			_attempt_catch()


func _cast_line() -> void:
	_change_state(State.WAITING)


func _hook_fish() -> void:
	_change_state(State.HOOKED)

	new_fish = fisher.hook_fish()
	minigame.start(new_fish.colour)


func _attempt_catch() -> void:
	var result: Minigame.Result = minigame.end()

	match result:
		0:
			_miss_fish()
		1:
			message.show_text("keep trying!")
			minigame.start(new_fish.colour)
		2:
			_catch_fish()
		3:
			_catch_fish()


func _catch_fish() -> void:
	fish_log.add_fish(new_fish)

	# play animation of fish coming out of water

	if new_fish.size_inches > fisher.size_inches:
		fisher.replace_fisher(new_fish)

	_change_state(State.READY)


func _miss_cast() -> void:
	message.show_text("nothing :(")
	_change_state(State.READY)


func _miss_fish() -> void:
	# play animation
	message.show_text("it got away...")
	_change_state(State.READY)


func _on_cast_timer_timeout() -> void:
	_change_state(State.BITE)


func _on_bite_timer_timeout() -> void:
	_change_state(State.READY)


func _change_state(next_state: State) -> void:
	current_state = next_state

	match next_state:
		State.READY:
			bobber.hide_bobber()
		State.WAITING:
			bobber.show_bobber()
		State.BITE:
			bobber.show_label()
		State.HOOKED:
			bobber.hook_fish()
