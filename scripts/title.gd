extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FILE_PATH: String = "res://scenes/game.tscn"

var animations_finished: bool = false
var current_line: Line = Line.ZERO

enum Line {
	ZERO,
	ONE,
	TWO,
	THREE
}


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("RESET")
	TransitionScreen.transition_finished.connect(_start_game)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and animations_finished:
		_advance_to_next()


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "RESET":
		animation_player.play("title")
	elif animation_name == "title":
		animation_player.play("label")
	elif animation_name == "start_game":
		AudioManager.fade_out()
		TransitionScreen.fade_to_black()
	else:
		animations_finished = true


func _advance_to_next() -> void:
	match current_line:
		Line.ZERO:
			animations_finished = false
			current_line = Line.ONE
			AudioManager.play_perfect_catch()
			animation_player.play("fish_controls")
		Line.ONE:
			animations_finished = false
			current_line = Line.TWO
			AudioManager.play_normal_catch()
			animation_player.play("log_controls")
		Line.TWO:
			animations_finished = false
			current_line = Line.THREE
			AudioManager.play_normal_catch()
			animation_player.play("nav_controls")
		Line.THREE:
			animations_finished = false
			AudioManager.play_perfect_catch()
			animation_player.play("start_game")


func _start_game() -> void:
	get_tree().call_deferred("change_scene_to_file", FILE_PATH)
