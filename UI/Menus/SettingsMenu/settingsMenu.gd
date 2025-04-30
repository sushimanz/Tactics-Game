extends Menu

func _on_video_button_pressed() -> void:
	print("Video Button Pressed")

func _on_audio_button_pressed() -> void:
	print("Audio Button Pressed")

func _on_back_button_pressed() -> void:
	menuManager._go_back()
