class_name PKMenuButton
extends Button

@export var normal_brightness: float = 1.0
@export var pressed_brightness: float = 0.7
@export var hover_brightness: float = 1.3
@export var disabled_brightness: float = 0.5
var focused_brightness: float = hover_brightness

func _init() -> void:
	if disabled:
		set_brightness_percent_to(disabled_brightness)

#Got to be a better name but this works for now
func set_brightness_percent_to(light_percent: float) -> void:
	modulate.r = light_percent
	modulate.g = light_percent
	modulate.b = light_percent


func _on_button_down() -> void:
	set_brightness_percent_to(pressed_brightness)

func _on_pressed() -> void:
	#Set to hover brightness, since when it is pressed that means it is up again
	set_brightness_percent_to(hover_brightness)


func _on_mouse_entered() -> void:
	set_brightness_percent_to(hover_brightness)

func _on_mouse_exited() -> void:
	set_brightness_percent_to(normal_brightness)


func _on_focus_entered() -> void:
	set_brightness_percent_to(focused_brightness)

func _on_focus_exited() -> void:
	set_brightness_percent_to(normal_brightness)
