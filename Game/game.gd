extends Control

signal _update_mainstate(next_state: Main.MAINSTATE)
signal _open_menu(menu: PackedScene, is_popup: bool)

var timer = ResData.timer
var gameloop = GameloopData.new()

@export var max_rounds: int = 30
var current_rounds: int = 0

@export var max_actions: int = 5
var current_actions: int = 0

func _init_game(h: int = ResData.grid.cur_height, w: int = ResData.grid.cur_width) -> void:
	gameloop.reset_gamestates()
	%Grid.set_grid(h, w)
	%Timer.wait_time = timer.select_time
	%Timer.start()

func _start_round() -> void:
	##Caused by timer
	print("Squad: ", SquadData.friendly_troops)

func _end_game() -> void:
	var tiles = %Grid.get_children()
	for tile in tiles:
		tile.queue_free()
	
	%Timer.stop()
	##FIXME Make sure to change this, it is a temporary workaround
	#update_mainstate(Main.MAINSTATE.ENTER_TITLE)

#Can figure out how to make this better later
func update_mainstate(next_mainstate: Main.MAINSTATE):
	_update_mainstate.emit(next_mainstate)

func _physics_process(_delta: float) -> void:
	print("Time left: ", %Timer.time_left)

func _on_timer_timeout() -> void:
	if gameloop.gamestate == GameloopData.GAMESTATE.ROUND:
		#Round is checked first, since ROUND state is used the most
		if gameloop.roundstate == GameloopData.ROUNDSTATE.START:
			current_rounds += 1
			if current_rounds >= max_rounds:
				print("Last Round!")
			#Round planning (plan out troop movement), caused by round START ended
			gameloop.update_roundstate(GameloopData.ROUNDSTATE.PLANNING)
			%Timer.wait_time = timer.plan_time
		elif gameloop.roundstate == GameloopData.ROUNDSTATE.PLANNING:
			#Round acting (planning goes into action), caused by round PLANNING ended
			gameloop.update_roundstate(GameloopData.ROUNDSTATE.ACTING)
			%Timer.wait_time = timer.action_time
		elif gameloop.roundstate == GameloopData.ROUNDSTATE.ACTING:
			current_actions += 1
			if current_actions >= max_actions:
				print("Last Action!")
			if  current_actions > max_actions:
				#Round end, caused by round ACTING ended
				gameloop.update_roundstate(GameloopData.ROUNDSTATE.END)
				%Timer.wait_time = timer.end_time
		elif gameloop.roundstate == GameloopData.ROUNDSTATE.END:
			if current_rounds > max_rounds:
				#Scoreboard, caused by all rounds ended, or some player win/loss/tie condition
				_end_game()
				gameloop.update_gamestate(GameloopData.GAMESTATE.SCORE)
				_open_menu.emit(UIData.scoreboard_menu, true)
			else:
				#Round started, caused by new round created OR on round END ended
				gameloop.update_roundstate(GameloopData.ROUNDSTATE.START)
				%Timer.wait_time = timer.start_time
			
	
	else:
		if gameloop.gamestate == GameloopData.GAMESTATE.INIT:
			#Troop selection menu, caused by game hosted
			gameloop.update_gamestate(GameloopData.GAMESTATE.SELECT)
			%Timer.wait_time = timer.select_time
		elif gameloop.gamestate == GameloopData.GAMESTATE.SELECT:
			#Troop deployment, caused by timer/players ready from troop selection menu
			gameloop.update_gamestate(GameloopData.GAMESTATE.DEPLOY)
			%Timer.wait_time = timer.deploy_time
		elif gameloop.gamestate == GameloopData.GAMESTATE.DEPLOY:
			#Go to round state when deployment is over
			gameloop.update_gamestate(GameloopData.GAMESTATE.ROUND)
			#No need to update timer for round, each section of the round has its own timer
		elif gameloop.gamestate == GameloopData.GAMESTATE.SCORE:
			#Need to make UI for this, should pop up after a player win/tie/loss
			#No need to update timer for scoreboard, this is the end of the game
			pass
	
	%Timer.start()
