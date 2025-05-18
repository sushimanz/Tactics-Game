class_name Main
extends Control

##NOTE: Main Class is the "root" for the whole game

##TODO Figure out how to choose whether to do multiplayer or not, could be done here but might be nice if you can just open it in game
#var is_multiplayer: bool = false

##NOTE: For each manager, there is a data class. 
##If there is a problem with the input, check the calls in this script, or the data scripts

#Managers and their instance references
@onready var inst_game_cam: Node = $GameCamera
@onready var inst_game: Node = $Game
@onready var inst_menu_manager: Node = $MenuManager
@onready var inst_music_manager: Node = $MusicManager

##NOTE: This stuff works for now but might want to change a couple names or something else, idk
enum MAINSTATE {
	#Boot
	ENTER_BOOT, 
	EXIT_BOOT, 
	
	#Title (Main menu)
	ENTER_TITLE, 
	EXIT_TITLE, 
	
	#Game - might want to ren ame some of these
	#ENTER_GAME - happens when you are selecting a match type - this only happens the first time you open or on rematch
	ENTER_GAME,
	#START_GAME - happens directly after ENTER_GAME, and you select your troops here... Just call TROOP_SELECT?
	START_GAME,
	#PLAY_GAME - happens directly after START_GAME, troops are selected
	PLAY_GAME,
	#EXIT_GAME - happens directly after the game is exited (so that Game becomes invisible)
	EXIT_GAME,
	
	#User Settings
	CONFIG_USER,
	
	#Do this to exit/quit the game
	EXIT
	}

var current_mainstate: MAINSTATE = MAINSTATE.ENTER_BOOT
var previous_mainstate: MAINSTATE = MAINSTATE.ENTER_BOOT

#This needs to have a better way to update
static var popup_mainstate: MAINSTATE = MAINSTATE.ENTER_TITLE

func _ready() -> void:
	#Go to menu since nothing to boot yet
	update_mainstate(MAINSTATE.ENTER_TITLE)
	inst_menu_manager._update_mainstate.connect(update_mainstate)

func update_mainstate(next_mainstate: MAINSTATE) -> void:
	if next_mainstate == current_mainstate:
		var mainstate_keys = MAINSTATE.keys()
		
		print(
			"\n*** Main update_mainstate() call ***",
			"\n\tInvalid next_mainstate: ", mainstate_keys[next_mainstate],
			"\n\tThis is the same mainstate as the current mainstate!\n"
		)
	
	else:
		inst_game_cam.position = inst_game_cam.spawn_pos
		inst_game_cam.zoom = inst_game_cam.zoom_default
		inst_game.visible = false
		
		match next_mainstate:
			MAINSTATE.ENTER_BOOT:
				print("\nENTER_BOOT")
				
			MAINSTATE.EXIT_BOOT:
				print("\nEXIT_BOOT")
				
			MAINSTATE.ENTER_TITLE:
				print("\nENTER_TITLE")
				popup_mainstate = MAINSTATE.EXIT
				inst_menu_manager.clean_menus()
				inst_menu_manager.goto_menu(MenuData.main_menu)
				inst_music_manager.play_random_track_from_album(MusicData.album_intros)
				
			MAINSTATE.EXIT_TITLE:
				#What to do when the title/main menu is exited (Not when going into the game)
				print("\nEXIT_TITLE")
				inst_menu_manager.goto_menu(MenuData.are_you_sure_popup_menu)
				#Need to pass in the next mainstate (In this case only EXIT)
				
			MAINSTATE.ENTER_GAME:
				print("\nENTER_GAME")
				popup_mainstate = MAINSTATE.ENTER_TITLE
				inst_menu_manager.clean_menus()
				inst_menu_manager.goto_menu(MenuData.game_menu)
				inst_music_manager.play_random_track_from_album(MusicData.album_selects)
				
			MAINSTATE.START_GAME:
				print("\nSTART_GAME")
				inst_menu_manager.clean_menus()
				inst_menu_manager.goto_menu(MenuData.troop_selection_menu)
				inst_music_manager.play_random_track_from_album(MusicData.album_selects)
				inst_game._start_game()
				
			MAINSTATE.PLAY_GAME:
				print("\nPLAY_GAME")
				inst_menu_manager.clean_menus()
				inst_game.visible = true
				
			MAINSTATE.EXIT_GAME:
				#What to do when the game is exited, to menu or full exit
				print("\nEXIT_GAME")
				#Need to pass in the next mainstate (In this case could be ENTER_TITLE or EXIT)
				
			MAINSTATE.CONFIG_USER:
				#Save data, load data, etc
				print("\nCONFIG_USER")
				
			MAINSTATE.EXIT:
				print("\nEXIT")
				#Call anything else before fully quitting
				get_tree().quit()
		
		previous_mainstate = current_mainstate
		current_mainstate = next_mainstate
