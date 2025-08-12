extends CanvasLayer


@onready var animation_player: AnimationPlayer = $TextureRect/ColorRect/AnimationPlayer


func _ready() -> void:
	hide()


func start() -> void:
	show()
	
