class_name TroopSelectionMenu
extends UI

func _ready() -> void:
	pass

func _on_back_button_pressed() -> void:
	_go_back()

func _on_next_button_pressed() -> void:
	$"../..".visible = true
	GameloopData.gamestate = GameloopData.GAMESTATE.DEPLOY
	_update_mainstate(Main.MAINSTATE.PLAY_GAME)
	%PortraitUI.set_portraits()
	%PortraitUI.visible = true
	visible = false
