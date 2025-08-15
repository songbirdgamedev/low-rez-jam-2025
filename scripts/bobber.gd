class_name Bobber
extends Node2D


@onready var label: Label = $Sprite/Label
@onready var cast_timer: Timer = $CastTimer
@onready var bite_timer: Timer = $BiteTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	label.hide()
	animation_player.animation_finished.connect(_on_animation_finished)
	cast_timer.timeout.connect(_on_cast_timer_timeout)


func cast_line() -> void:
	animation_player.play("cast")


func reel_in() -> void:
	if not cast_timer.is_stopped():
		cast_timer.stop()

	AudioManager.play_splash()
	label.hide()
	animation_player.play("reel")


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "cast":
		_on_cast_line_finished()


func _on_cast_line_finished() -> void:
	AudioManager.play_splash()
	animation_player.play("move")
	cast_timer.start(randf_range(2.0, 5.0))


func _on_cast_timer_timeout() -> void:
	animation_player.pause()
	label.show()
	AudioManager.play_bloop()
	bite_timer.start() # maybe change time based on rarity?
