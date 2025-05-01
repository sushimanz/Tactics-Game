class_name PKMenuButton
extends PKButton

@export var is_selection_button: bool = false
var is_selected: bool = false

func _init() -> void:
	if disabled:
		set_brightness_percent_to(disabled_brightness)

#Got to be a better name but this works for now
func set_brightness_percent_to(light_percent: float) -> void:
	modulate.r = light_percent
	modulate.g = light_percent
	modulate.b = light_percent


func _on_button_down() -> void:
	if !is_selection_button:
		set_brightness_percent_to(pressed_brightness)
	else:
		is_selected = true
		set_brightness_percent_to(selected_brightness)

func _on_pressed() -> void:
	#Set to hover brightness, since when it is pressed that means it is up again
	if !is_selected:
		set_brightness_percent_to(hover_brightness)


func _on_mouse_entered() -> void:
	if !is_selected:
		set_brightness_percent_to(hover_brightness)

func _on_mouse_exited() -> void:
	if !is_selected:
		set_brightness_percent_to(normal_brightness)


func _on_focus_entered() -> void:
	if !is_selected:
		set_brightness_percent_to(focused_brightness)

func _on_focus_exited() -> void:
	if !is_selected:
		set_brightness_percent_to(normal_brightness)
