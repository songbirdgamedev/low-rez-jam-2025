extends AnimatedSprite2D


@onready var label: Label = $Label
@onready var cast_timer: Timer = $CastTimer
@onready var bite_timer: Timer = $BiteTimer
@onready var message: CanvasLayer = %Message


func _ready() -> void:
	hide()
	label.hide()
	cast_timer.timeout.connect(_fish_bite)
	bite_timer.timeout.connect(_fish_got_away)


func show_bobber() -> void:
	show()
	# make sound

	# start timer with random timeout
	cast_timer.start(randf_range(2.0, 5.0))


func hide_bobber() -> void:
	hide()
	# make sound


func _fish_bite() -> void:
	pause()
	label.show()
	# play sound
	bite_timer.start() # maybe change time based on rarity?


func _fish_got_away() -> void:
	hide()
	label.hide()
	message.show_text("it got away...")
