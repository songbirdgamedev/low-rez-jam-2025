extends AnimatedSprite2D


@onready var label: Label = $Label
@onready var cast_timer: Timer = $CastTimer
@onready var bite_timer: Timer = $BiteTimer
@onready var game_manager: Node = %GameManager


signal bite_missed


func _ready() -> void:
	hide()
	label.hide()
	cast_timer.timeout.connect(_fish_bite)
	bite_timer.timeout.connect(_fish_got_away)
	game_manager.line_cast.connect(_show_bobber)
	game_manager.fish_hooked.connect(_hook_fish)
	game_manager.fish_missed.connect(_hide_bobber)
	game_manager.fish_caught.connect(_hide_bobber)


func _show_bobber() -> void:
	# animate cast
	play("default")
	show()
	# make sound

	# start timer with random timeout
	cast_timer.start(randf_range(2.0, 5.0))


func _fish_bite() -> void:
	pause()
	label.show()
	# play sound
	bite_timer.start() # maybe change time based on rarity?


func _hook_fish() -> void:
	bite_timer.stop()


func _fish_got_away() -> void:
	bite_missed.emit()


func _hide_bobber() -> void:
	hide()
	label.hide()
	# make sound
