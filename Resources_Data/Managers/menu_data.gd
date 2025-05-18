class_name MenuData
extends Resource

#Could try to find a way to get the menus dynamically, maybe with ../Menus/**.tscn or something? Excluding the MenuManager.tscn
static var main_menu: PackedScene = load("res://UI/Menus/MainMenu/MainMenu.tscn")
static var settings_menu: PackedScene = load("res://UI/Menus/SettingsMenu/SettingsMenu.tscn")
static var credits_menu: PackedScene

static var game_menu: PackedScene = load("res://UI/Menus/GameMenu/GameMenu.tscn")
static var troop_selection_menu: PackedScene = load("res://UI/Menus/TroopSelectionMenu/TroopSelectionMenu.tscn")

static var are_you_sure_popup_menu: PackedScene = load("res://UI/Menus/PopupMenus/AreYouSurePopupMenu.tscn")
