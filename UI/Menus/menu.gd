class_name Menu
extends Control

#Made a boolean to make it simpler check for a root ui (basically a required part of the ui to do something)
@export var is_root_ui: bool = false

#Causes a debugger flag for not being used in this class
signal update_mainstate(next_state: Main.MAINSTATE)
signal go_back()
signal goto_menu(next_scene: PackedScene)

func _update_mainstate(next_state: Main.MAINSTATE):
	update_mainstate.emit(next_state)

func _go_back():
	go_back.emit()

func _goto_menu(next_scene: PackedScene):
	goto_menu.emit(next_scene)
