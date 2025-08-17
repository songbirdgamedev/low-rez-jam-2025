extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FILE_PATH: String = "res://scenes/game.tscn"

var animations_finished: bool = false


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and animations_finished:
		get_tree().call_deferred("change_scene_to_file", FILE_PATH)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "title":
		animation_player.play("label")
	elif animation_name == "label":
		animations_finished = true
