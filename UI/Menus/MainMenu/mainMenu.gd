extends Menu

func _on_host_button_pressed() -> void:
	print("Host Button Pressed")

func _on_copy_button_pressed() -> void:
	print("Copy Button Pressed")

func _on_join_button_pressed() -> void:
	print("Join Button Pressed")

func _on_play_button_pressed() -> void:
	print("Play Button Pressed")

func _on_credits_button_pressed() -> void:
	print("Credits Button Pressed")

func _on_settings_button_pressed() -> void:
	menuManager._goto_menu(MenuData.settings_menu)

func _on_quit_button_pressed() -> void:
	main.update_mainstate(main.MAINSTATE.EXIT)
