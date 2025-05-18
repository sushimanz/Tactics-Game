class_name PKButton
extends Button

@export var normal_brightness: float = 1.0
@export var pressed_brightness: float = 0.7
@export var hover_brightness: float = 1.3
@export var disabled_brightness: float = 0.5
var focused_brightness: float = hover_brightness
var selected_brightness: float = (normal_brightness + hover_brightness)# / 2
