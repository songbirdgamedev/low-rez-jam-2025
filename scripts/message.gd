extends CanvasLayer


@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer


func _ready() -> void:
	_hide_text()
	timer.timeout.connect(_hide_text)


func _hide_text() -> void:
	label.text = ""


func show_text(message: String) -> void:
	label.text = message
	timer.start()


func show_failure_text() -> void:
	show_text("it got away...")
