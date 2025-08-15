extends Node


@onready var bloop: AudioStreamPlayer = $Bloop
@onready var reel: AudioStreamPlayer = $Reel
@onready var splash: AudioStreamPlayer = $Splash
@onready var chomp: AudioStreamPlayer = $Chomp
@onready var normal_catch: AudioStreamPlayer = $NormalCatch
@onready var perfect_catch: AudioStreamPlayer = $PerfectCatch
@onready var open_log: AudioStreamPlayer = $OpenLog
@onready var close_log: AudioStreamPlayer = $CloseLog
@onready var turn_page: AudioStreamPlayer = $TurnPage


func play_bloop() -> void:
	bloop.play()


func play_reel() -> void:
	reel.play()


func stop_reel() -> void:
	reel.stop()


func play_splash() -> void:
	splash.play()


func play_chomp() -> void:
	chomp.play()


func play_normal_catch() -> void:
	normal_catch.play()


func play_perfect_catch() -> void:
	perfect_catch.play()


func play_open_log() -> void:
	open_log.play()


func play_close_log() -> void:
	close_log.play()


func play_turn_page() -> void:
	turn_page.play()
