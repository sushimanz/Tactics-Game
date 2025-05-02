extends PKPopupMenu

func _on_yes_button_pressed() -> void:
	#How to pass in a function call, since the "Are You Sure" popup menu could close the game, or go back to another menu instance
	main.update_mainstate(main.popup_mainstate)

func _on_no_button_pressed() -> void:
	menuManager._go_back()
