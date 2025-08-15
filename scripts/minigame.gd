class_name Minigame
extends CanvasLayer


@onready var animation_player: AnimationPlayer = $TextureRect/ColorRect/AnimationPlayer
@onready var color_rect: ColorRect = $TextureRect/ColorRect
@onready var start_timer: Timer = $StartTimer
@onready var retry_timer: Timer = $RetryTimer
@onready var end_timer: Timer = $EndTimer
@onready var message: CanvasLayer = %Message

var current_fish: Fish.Colour
var result: Result

enum Result {
	MISSED,
	CAUGHT,
	PERFECT
}

signal minigame_over(result: Result)


func _ready() -> void:
	_hide_and_reset()
	start_timer.timeout.connect(_on_start_timer_timeout)
	retry_timer.timeout.connect(_on_retry_timer_timeout)
	end_timer.timeout.connect(_on_end_timer_timeout)


func start_minigame(fish_colour: Fish.Colour) -> void:
	current_fish = fish_colour

	match fish_colour:
		0:
			animation_player.speed_scale = 1.0
		1, 2:
			animation_player.speed_scale = 1.2
		3:
			animation_player.speed_scale = 1.4
		4, 5:
			animation_player.speed_scale = 1.6
		6:
			animation_player.speed_scale = 1.8
		7:
			animation_player.speed_scale = 2.0

	animation_player.play("move")
	show()


func stop_minigame() -> void:
	if not animation_player.is_playing():
		return

	animation_player.pause()
	var x: float = color_rect.get_position().x

	if x < 6.0 or x > 42.0:
		result = Result.MISSED
		message.show_failure_text()
	elif x < 18.0 or x > 30.0:
		message.show_text("keep trying!")
		retry_timer.start()
		return
	elif x < 22.0 or x > 26.0:
		result = Result.CAUGHT
	else:
		result = Result.PERFECT
		message.show_text("perfect catch!")

	start_timer.stop()
	end_timer.start()


func _on_visibility_changed() -> void:
	if is_visible():
		start_timer.start()


func _on_start_timer_timeout() -> void:
	result = Result.MISSED
	message.show_failure_text()
	_hide_and_reset()
	_send_result()


func _on_retry_timer_timeout() -> void:
	_reset_animation()
	start_minigame(current_fish)


func _on_end_timer_timeout() -> void:
	_hide_and_reset()
	_send_result()


func _send_result() -> void:
	minigame_over.emit(result)


func _hide_and_reset() -> void:
	hide()
	_reset_animation()


func _reset_animation() -> void:
	animation_player.play("RESET")
