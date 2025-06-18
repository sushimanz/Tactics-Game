class_name UIData
extends Resource

#Could try to find a way to get the menus dynamically, maybe with ../Menus/**.tscn or something? Excluding the MenuManager.tscn
static var main_menu: PackedScene = load("res://UI/Menus/MainMenu/MainMenu.tscn")
static var settings_menu: PackedScene = load("res://UI/Menus/SettingsMenu/SettingsMenu.tscn")
static var credits_menu: PackedScene

static var lobby_menu: PackedScene = load("res://UI/Menus/LobbyMenu/LobbyMenu.tscn")

#These go in the game itself, so don't need these here anymore (Probably)
#static var portrait_ui: PackedScene = load("res://UI/Misc/PortraitUI/PortraitUI.tscn")
#static var troop_selection_menu: PackedScene = load("res://UI/Menus/TroopSelectionMenu/TroopSelectionMenu.tscn")
#static var scoreboard_menu: PackedScene

static var are_you_sure_popup_menu: PackedScene = load("res://UI/Menus/PopupMenus/AreYouSurePopupMenu.tscn")
