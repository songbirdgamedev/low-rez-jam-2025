extends AnimatedSprite2D


@onready var label: Label = $Label
@onready var cast_timer: Timer = $CastTimer
@onready var bite_timer: Timer = $BiteTimer


signal bite_missed


func _ready() -> void:
	hide()
	label.hide()
	cast_timer.timeout.connect(_fish_bite)
	bite_timer.timeout.connect(_fish_got_away)


func show_bobber() -> void:
	play("default")
	show()
	# make sound

	# start timer with random timeout
	cast_timer.start(randf_range(2.0, 5.0))


func hide_bobber() -> void:
	hide()
	# make sound


func hook_fish() -> void:
	bite_timer.stop()


func _fish_bite() -> void:
	pause()
	label.show()
	# play sound
	bite_timer.start() # maybe change time based on rarity?


func _fish_got_away() -> void:
	hide()
	label.hide()
	bite_missed.emit()
