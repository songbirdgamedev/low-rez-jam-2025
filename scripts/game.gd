class_name Game
extends Node2D


@onready var fisher: Fisher = %Fisher
@onready var bobber: Node2D = %Bobber
@onready var minigame: CanvasLayer = %Minigame
@onready var message: CanvasLayer = %Message
@onready var fish_log: CanvasLayer = %FishLog
@onready var particle: GPUParticles2D = %Particle

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
	minigame.minigame_over.connect(_on_minigame_end)
	particle.finished.connect(_handle_replace_fisher)


func _process(_delta: float) -> void:
	if (
		bobber.animation_player.get_current_animation() == "cast" or
		bobber.animation_player.get_current_animation() == "reel"
	):
		return

	if Input.is_action_just_pressed("menu") and current_state == State.READY:
		if fish_log.is_visible():
			fish_log.hide()
		else:
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
				minigame.start_minigame(new_fish.colour)
			State.HOOKED:
				minigame.stop_minigame()


func _on_cast_timer_timeout() -> void:
	_change_state(State.BITE)


func _on_bite_timer_timeout() -> void:
	bobber.reel_in()
	message.show_failure_text()
	_change_state(State.READY)


func _on_minigame_end(result: Minigame.Result) -> void:
	bobber.reel_in()
	_change_state(State.READY)

	await bobber.animation_player.animation_finished
	if result != 0:
		# play animation of fish coming out of water
		fish_log.add_fish(new_fish)
		if fisher.check_size(new_fish):
			particle.set_emitting(true)


func _handle_replace_fisher() -> void:
	message.show_text("fisher eaten!")
	fisher.replace_fisher(new_fish)


func _change_state(next_state: State) -> void:
	current_state = next_state
