class_name Minigame
extends CanvasLayer


@onready var animation_player: AnimationPlayer = $TextureRect/ColorRect/AnimationPlayer
@onready var color_rect: ColorRect = $TextureRect/ColorRect
@onready var end_timer: Timer = $EndTimer
@onready var try_again_timer: Timer = $TryAgainTimer


enum Result {
	MISSED,
	TRYAGAIN,
	CAUGHT,
	PERFECT
}


func _ready() -> void:
	_hide_and_reset()
	end_timer.timeout.connect(_hide_and_reset)


func start(fish_colour: Fish.Colour) -> void:
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


func end() -> Result:
	animation_player.pause()
	var x: float = color_rect.get_position().x

	if x < 6.0 or x > 42.0:
		end_timer.start()
		return Result.MISSED
	elif x < 18.0 or x > 30.0:
		try_again_timer.start()
		return Result.TRYAGAIN
	elif x < 22.0 or x > 26.0:
		end_timer.start()
		return Result.CAUGHT
	else:
		end_timer.start()
		return Result.PERFECT


func _hide_and_reset() -> void:
	hide()
	animation_player.play("RESET")
