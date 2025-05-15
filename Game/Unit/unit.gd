class_name Unit
extends Control

@onready var sprite = $Sprite2D

func _init() -> void:
	pass

func _ready() -> void:
	sprite.play("idle")
	tooltip_text = "TestTroop\nHealth: 0\nReinforcements: 0"
