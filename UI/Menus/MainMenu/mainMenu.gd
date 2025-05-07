extends Menu

#Copies the OID or if multiplayer stuff changes, whatever input might be needed
func _on_copy_button_pressed() -> void:
	print("Copy Button Pressed")

#Host, join, and play all will "open" the game, but need a way to tell whether it is going to be host vs join vs play (Just goes to play by default)
func _on_host_button_pressed() -> void:
	print("Host Button Pressed")

func _on_join_button_pressed() -> void:
	print("Join Button Pressed")

func _on_play_button_pressed() -> void:
	print("Play Button Pressed")
	_update_mainstate.emit(Main.MAINSTATE.ENTER_GAME)

#Self-explanatory buttons
func _on_credits_button_pressed() -> void:
	print("Credits Button Pressed")
	
	#Will be separate menu in the future
	print(
	"\n\tArtists: Waffles",
	"\n\tMusic: Moon",
	"\n\tVoice Actors: Anexi, boredboi, MaskenVA, Jen",
	"\n\tProgramming & Development: Jafoolery, Jakobre, JustAutoAttack, Snipershot, Sushimanz",
	"\n"
	)
	
	#menuManager._goto_menu(MenuData.credits_menu)

func _on_settings_button_pressed() -> void:
	_goto_menu.emit(MenuData.settings_menu)

func _on_quit_button_pressed() -> void:
	_update_mainstate.emit(Main.MAINSTATE.EXIT)
