class_name Main
extends Node

##TODO Figure out how to choose whether to do multiplayer or not, could be done here but might be nice if you can just open it in game
#var is_multiplayer: bool = false

#Managers
@export var menu_manager: PackedScene = load("res://UI/Menus/MenuManager.tscn")
@onready var inst_menu_manager: Node = menu_manager.instantiate()

enum MAINSTATE {
	#Boot
	ENTER_BOOT, 
	EXIT_BOOT, 
	
	#Title (Main menu)
	ENTER_TITLE, 
	EXIT_TITLE, 
	
	#Game
	ENTER_GAME,
	EXIT_GAME,
	
	#User Settings
	CONFIG_USER,
	
	#Do this to exit/quit the game
	EXIT
	}


func _ready() -> void:
	#Go to menu since nothing to boot yet
	#Add all managers here 	<-- Is it better to do this, or should it all just be in the main menu already?
	add_child(inst_menu_manager)
	update_mainstate(MAINSTATE.ENTER_TITLE)

func update_mainstate(mainstate: MAINSTATE) -> void:
	match mainstate:
		MAINSTATE.ENTER_BOOT:
			pass
		MAINSTATE.EXIT_BOOT:
			pass
		MAINSTATE.ENTER_TITLE:
			inst_menu_manager._goto_menu(MenuData.main_menu)
		MAINSTATE.EXIT_TITLE:
			#What to do when the title/main menu is exited, to game or full exit
			pass
		MAINSTATE.ENTER_GAME:
			pass
		MAINSTATE.EXIT_GAME:
			#What to do when the game is exited, to menu or full exit
			pass
		MAINSTATE.CONFIG_USER:
			#Save data, load data, etc
			pass
		MAINSTATE.EXIT:
			#Call anything else before fully quitting
			get_tree().quit()
