class_name Bobber
extends Node2D


@onready var label: Label = $Sprite/Label
@onready var cast_timer: Timer = $CastTimer
@onready var bite_timer: Timer = $BiteTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()
	label.hide()


func hide_bobber() -> void:
	hide()
	label.hide()
	# make sound

	if not cast_timer.is_stopped():
		cast_timer.stop()


func show_bobber() -> void:
	# animate cast
	animation_player.play("move")
	show()
	# make sound

	cast_timer.start(randf_range(2.0, 5.0))


func show_label() -> void:
	animation_player.pause()
	label.show()
	# make sound

	bite_timer.start() # maybe change time based on rarity?


func hook_fish() -> void:
	bite_timer.stop()
