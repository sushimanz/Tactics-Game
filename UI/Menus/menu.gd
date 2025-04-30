class_name Menu
extends Control

#Made a boolean to make it simpler check for a root ui (basically a required part of the ui to do something)
@export var is_root_ui: bool = false

@onready var main = get_tree().root.get_child(0)
@onready var menuManager = get_parent()
