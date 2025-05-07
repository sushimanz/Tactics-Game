extends Menu

func _on_back_button_pressed() -> void:
	_go_back.emit()

func _on_next_button_pressed() -> void:
	_update_mainstate.emit(Main.MAINSTATE.START_GAME)
