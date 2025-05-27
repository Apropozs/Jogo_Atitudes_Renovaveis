extends Control

@onready var timingBar = $timingBar
var vidas = 5
var placas_instaladas = 0

func _ready():
	timingBar.visible = false

func _on_Placa1_pressed() -> void:
	timingBar.visible = true
