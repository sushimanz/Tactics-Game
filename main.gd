class_name Main
extends Node

##TODO Figure out how to choose whether to do multiplayer or not, could be done here but might be nice if you can just open it in game
#var is_multiplayer: bool = false

##NOTE: For each manager, there is a data class. 
##If there is a problem with the input, check the calls in this script, or the data scripts

#Managers and their instance references
@export var menu_manager: PackedScene = load("res://UI/Menus/MenuManager.tscn")
@onready var inst_menu_manager: Node = menu_manager.instantiate()
@export var music_manager: PackedScene = load("res://Audio/Music/MusicManager.tscn")
@onready var inst_music_manager: Node = music_manager.instantiate()

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

var current_mainstate: MAINSTATE = MAINSTATE.ENTER_BOOT

func _ready() -> void:
	#Go to menu since nothing to boot yet
	#Add all managers here 	<-- Is it better to do this, or should it all just be in the main menu already?
	add_child(inst_menu_manager)
	add_child(inst_music_manager)
	update_mainstate(MAINSTATE.ENTER_TITLE)

func update_mainstate(mainstate: MAINSTATE) -> void:
	match mainstate:
		MAINSTATE.ENTER_BOOT:
			current_mainstate = MAINSTATE.ENTER_BOOT
			print("\nENTER_BOOT")
			
		MAINSTATE.EXIT_BOOT:
			current_mainstate = MAINSTATE.EXIT_BOOT
			print("\nEXIT_BOOT")
			
		MAINSTATE.ENTER_TITLE:
			current_mainstate = MAINSTATE.ENTER_TITLE
			print("\nENTER_TITLE")
			inst_menu_manager._clean_menus()
			inst_menu_manager._goto_menu(MenuData.main_menu)
			inst_music_manager.play_random_track_from_album(MusicData.album_intros)
			
		MAINSTATE.EXIT_TITLE:
			#What to do when the title/main menu is exited, to game or full exit
			current_mainstate = MAINSTATE.EXIT_TITLE
			print("\nEXIT_TITLE")
			
		MAINSTATE.ENTER_GAME:
			current_mainstate = MAINSTATE.ENTER_GAME
			print("\nENTER_GAME")
			inst_menu_manager._clean_menus()
			inst_menu_manager._goto_menu(MenuData.game_menu)
			inst_music_manager.play_random_track_from_album(MusicData.album_selects)
			
		MAINSTATE.EXIT_GAME:
			#What to do when the game is exited, to menu or full exit
			current_mainstate = MAINSTATE.EXIT_GAME
			print("\nEXIT_GAME")
			
		MAINSTATE.CONFIG_USER:
			#Save data, load data, etc
			current_mainstate = MAINSTATE.CONFIG_USER
			print("\nCONFIG_USER")
			
		MAINSTATE.EXIT:
			current_mainstate = MAINSTATE.EXIT
			print("\nEXIT")
			#Call anything else before fully quitting
			get_tree().quit()
