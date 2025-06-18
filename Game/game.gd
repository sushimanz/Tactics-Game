extends Control

signal _update_mainstate(next_state: Main.MAINSTATE)

var timer: TimerData = ResData.timer

@export var max_rounds: int = 30
var current_rounds: int = 0

@export var max_actions: int = 5
var current_actions: int = 0

@onready var game_cam: Camera2D = $GameCamera

func _ready() -> void:
	%PortraitUI.visible = false
	%TroopSelectionMenu.visible = false
	#%ScoreboardUI.visible = false
	
	%Grid._add_unit.connect(_on_grid_add_unit)
	%Friendlies._unit_selected.connect(unit_selected)

func unit_selected(unit_id: Unit = null) -> void:
	%Grid.selected_unit = unit_id

func _init_game(h: int = ResData.grid.cur_height, w: int = ResData.grid.cur_width) -> void:
	print("_init_game called")
	%GameUI.visible = true
	%PortraitUI.visible = false
	%TroopSelectionMenu.visible = true
	#%ScoreboardUI.visible = false
	
	game_cam.position = game_cam.spawn_pos
	game_cam.zoom = game_cam.zoom_default
	
	%PortraitUI.set_gamestate_text(GameloopData.GAMESTATE.keys()[GameloopData.gamestate])
	%PortraitUI.set_roundstate_text(GameloopData.ROUNDSTATE.keys()[GameloopData.roundstate])
	prev_time_left = int(%Timer.wait_time)
	
	GameloopData.reset_gamestates()
	%Grid.clear_grid()
	%Grid.set_grid(h, w)
	%Timer.wait_time = timer.select_time
	%Timer.start()

func _start_round() -> void:
	print("_start_round called")
	##Caused by timer
	print("Squad: ", SquadData.friendly_troops)

func _end_game() -> void:
	print("_end_game called")
	%GameUI.visible = false
	
	for tile in %Grid.get_children():
		tile.queue_free()
	for friendly in %Friendlies.get_children():
		friendly.queue_free()
	for enemy in %Enemies.get_children():
		enemy.queue_free()
	
	%Timer.stop()

func _exit_game() -> void:
	print("_exit_game called")
	_end_game()
	update_mainstate(Main.MAINSTATE.ENTER_TITLE)

#Can figure out how to make this better later
func update_mainstate(next_mainstate: Main.MAINSTATE):
	_update_mainstate.emit(next_mainstate)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_BACKSPACE:
		print("* Resetting Timer *")
		%Timer.start()

var prev_time_left: int

func _physics_process(_delta: float) -> void:
	var cur_time_left: int = int(%Timer.time_left)
	
	if prev_time_left < cur_time_left:
		#print("Update Text")
		prev_time_left = cur_time_left
		%PortraitUI.set_gamestate_text(GameloopData.GAMESTATE.keys()[GameloopData.gamestate])
		%PortraitUI.set_roundstate_text(GameloopData.ROUNDSTATE.keys()[GameloopData.roundstate])
		%PortraitUI.set_time_left_text(str(prev_time_left))
	
	if prev_time_left > cur_time_left:
		#print("Update Time")
		#print("Time Left: ", cur_time_left)
		prev_time_left = cur_time_left
		%PortraitUI.set_gamestate_text(GameloopData.GAMESTATE.keys()[GameloopData.gamestate])
		%PortraitUI.set_roundstate_text(GameloopData.ROUNDSTATE.keys()[GameloopData.roundstate])
		%PortraitUI.set_time_left_text(str(prev_time_left))

func _on_timer_timeout() -> void:
	print("Timer Timeout")
	if GameloopData.gamestate == GameloopData.GAMESTATE.ROUND:
		#Round is checked first, since ROUND state is used the most
		if GameloopData.roundstate == GameloopData.ROUNDSTATE.START:
			current_rounds += 1
			if current_rounds >= max_rounds:
				print("Last Round!")
			#Round planning (plan out troop movement), caused by round START ended
			GameloopData.update_roundstate(GameloopData.ROUNDSTATE.PLANNING)
			%Timer.wait_time = timer.plan_time
		elif GameloopData.roundstate == GameloopData.ROUNDSTATE.PLANNING:
			#Round acting (planning goes into action), caused by round PLANNING ended
			GameloopData.update_roundstate(GameloopData.ROUNDSTATE.ACTING)
			%Timer.wait_time = timer.action_time
		elif GameloopData.roundstate == GameloopData.ROUNDSTATE.ACTING:
			current_actions += 1
			if current_actions >= max_actions:
				print("Last Action!")
			if  current_actions > max_actions:
				#Round end, caused by round ACTING ended
				GameloopData.update_roundstate(GameloopData.ROUNDSTATE.END)
				%Timer.wait_time = timer.end_time
		elif GameloopData.roundstate == GameloopData.ROUNDSTATE.END:
			if current_rounds < max_rounds:
				#Round started, caused by new round created OR on round END ended
				GameloopData.update_roundstate(GameloopData.ROUNDSTATE.START)
				%Timer.wait_time = timer.start_time
			else:
				#Scoreboard, caused by all rounds ended, or some player win/loss/tie condition
				GameloopData.update_gamestate(GameloopData.GAMESTATE.SCORE)
				_end_game()
				#%ScoreboardUI.visible = true
			
	
	else:
		if GameloopData.gamestate == GameloopData.GAMESTATE.INIT:
			%TroopSelectionMenu.visible = true
			#Troop selection menu, caused by game hosted
			GameloopData.update_gamestate(GameloopData.GAMESTATE.SELECT)
			%Timer.wait_time = timer.select_time
		elif GameloopData.gamestate == GameloopData.GAMESTATE.SELECT:
			%PortraitUI.visible = true
			#Troop deployment, caused by timer/players ready from troop selection menu
			GameloopData.update_gamestate(GameloopData.GAMESTATE.DEPLOY)
			%Timer.wait_time = timer.deploy_time
		elif GameloopData.gamestate == GameloopData.GAMESTATE.DEPLOY:
			#Go to round state when deployment is over
			GameloopData.update_gamestate(GameloopData.GAMESTATE.ROUND)
			%Timer.wait_time = timer.start_time
			#No need to update timer for round, each section of the round has its own timer
		elif GameloopData.gamestate == GameloopData.GAMESTATE.SCORE:
			#Need to make UI for this, should pop up after a player win/tie/loss
			#No need to update timer for scoreboard, this is the end of the game
			pass
	
	%PortraitUI.set_gamestate_text(GameloopData.GAMESTATE.keys()[GameloopData.gamestate])
	%PortraitUI.set_roundstate_text(GameloopData.ROUNDSTATE.keys()[GameloopData.roundstate])
	prev_time_left = int(%Timer.wait_time)
	%Timer.start()


func _on_grid_add_unit(unit_id: Unit, is_friendly: bool) -> void:
	if is_friendly:
		%Friendlies.add_child(unit_id)
	else:
		%Enemies.add_child(unit_id)
