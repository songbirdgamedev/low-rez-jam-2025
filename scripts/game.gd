class_name Game
extends Node2D


@onready var fisher: Fisher = %Fisher
@onready var bobber: Node2D = %Bobber
@onready var minigame: CanvasLayer = %Minigame
@onready var message: CanvasLayer = %Message
@onready var score: CanvasLayer = %Score
@onready var fish_log: CanvasLayer = %FishLog
@onready var fish_sprite: Node2D = %FishSprite

var ready_to_fish: bool = false
var current_state: State = State.READY
var new_fish: Fish
var perfect_catch: bool
var all_fish_caught: bool = false

enum State {
	READY,
	WAITING,
	BITE,
	HOOKED,
	CAUGHT
}


func _ready() -> void:
	TransitionScreen.transition_finished.connect(_start_game)
	TransitionScreen.fade_in()

	bobber.cast_timer.timeout.connect(_on_cast_timer_timeout)
	bobber.bite_timer.timeout.connect(_on_bite_timer_timeout)

	minigame.minigame_over.connect(_on_minigame_end)

	fish_log.all_fish_caught.connect(_on_all_fish_caught)

	fish_sprite.fish_ready.connect(_on_fish_ready)
	fish_sprite.fisher_eaten.connect(_on_fisher_eaten)
	fish_sprite.catch_complete.connect(_on_catch_complete)


func _process(_delta: float) -> void:
	if (
		bobber.animation_player.get_current_animation() == "cast" or
		bobber.animation_player.get_current_animation() == "reel" or
		not ready_to_fish
	):
		return

	if Input.is_action_just_pressed("menu") and current_state == State.READY:
		if fish_log.is_visible():
			AudioManager.play_close_log()
			fish_log.hide()
		else:
			AudioManager.play_open_log()
			fish_log.show_log()
	elif Input.is_action_just_pressed("confirm") and not fish_log.is_visible():
		match current_state:
			State.READY:
				bobber.cast_line()
				_change_state(State.WAITING)
			State.WAITING:
				bobber.reel_in()
				message.show_text("nothing :(")
				_change_state(State.READY)
			State.BITE:
				bobber.bite_timer.stop()
				new_fish = fisher.hook_fish()

				_change_state(State.HOOKED)
				AudioManager.play_reel()
				minigame.start_minigame(new_fish.colour)
			State.HOOKED:
				minigame.stop_minigame()


func _start_game() -> void:
	ready_to_fish = true


func _on_cast_timer_timeout() -> void:
	_change_state(State.BITE)


func _on_bite_timer_timeout() -> void:
	bobber.reel_in()
	message.show_failure_text()
	_change_state(State.READY)


func _on_minigame_end(result: Minigame.Result) -> void:
	AudioManager.stop_reel()
	bobber.reel_in()

	if result == 0:
		_change_state(State.READY)
		return

	if result == 2:
		AudioManager.play_perfect_catch()
		perfect_catch = true
	else:
		perfect_catch = false

	_change_state(State.CAUGHT)
	await bobber.animation_player.animation_finished
	fish_sprite.show_sprite(new_fish.sprite_region)


func _on_all_fish_caught() -> void:
	all_fish_caught = true


func _on_fish_ready() -> void:
	var fish_message: String = fish_log.add_fish(new_fish)
	score.update_score(new_fish, perfect_catch)

	if fish_message != "":
		AudioManager.play_normal_catch()
		message.show_text(fish_message)
		await message.timer.timeout
	else:
		fish_sprite.stay()
		return

	if fisher.check_size(new_fish):
		message.show_text("new biggest!")
		fish_sprite.eat_fisher()
		AudioManager.play_chomp()
	else:
		fish_sprite.reset()


func _on_fisher_eaten() -> void:
	fisher.replace_fisher(new_fish)


func _on_catch_complete() -> void:
	if all_fish_caught:
		message.show_text("all fish caught!")
		AudioManager.play_perfect_catch()
		all_fish_caught = false

	_change_state(State.READY)


func _change_state(next_state: State) -> void:
	current_state = next_state
