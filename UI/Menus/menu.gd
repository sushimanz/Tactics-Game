class_name Menu
extends Control

#Made a boolean to make it simpler check for a root ui (basically a required part of the ui to do something)
@export var is_root_ui: bool = false

signal _update_mainstate(next_state: Main.MAINSTATE)
signal _go_back()
signal _goto_menu(next_scene: PackedScene)
