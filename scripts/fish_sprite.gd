extends Node2D


@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal fish_ready
signal catch_complete


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func show_sprite(sprite_region: Rect2i) -> void:
	sprite.set_region_rect(sprite_region)
	animation_player.play("show")


func eat_fisher() -> void:
	animation_player.play("eat")


func stay() -> void:
	animation_player.play("stay")


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "show":
		fish_ready.emit()
	elif animation_name == "eat" or animation_name == "stay":
		catch_complete.emit()
		animation_player.play("RESET")
