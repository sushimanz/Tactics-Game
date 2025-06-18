class_name GameloopData
extends Resource

##The states of the game overall
enum GAMESTATE {
	INIT, 		##What happens at the very beginning of the game being started?
	SELECT, 	##What happens when selecting troops
	DEPLOY, 	##What happens when deploying troops
	ROUND, 		##What happens when the game is ongoing
	SCORE		##What happens when the game has finished
}

##The states of a single round
enum ROUNDSTATE {
	START, 		##What happens at the start of a round
	PLANNING, 	##What happens when planning unit actions
	ACTING, 	##What happens when units are moving and attacking
	END			##What happens at the end of a round
}

var gamestate: GAMESTATE = GAMESTATE.INIT
var roundstate: ROUNDSTATE = ROUNDSTATE.START

func reset_gamestates() -> void:
	gamestate = GAMESTATE.INIT
	roundstate = ROUNDSTATE.START

func update_gamestate(state: GAMESTATE):
	match state:
		GAMESTATE.INIT:
			pass
		GAMESTATE.SELECT:
			pass
		GAMESTATE.DEPLOY:
			pass
		GAMESTATE.ROUND:
			update_roundstate(ROUNDSTATE.START)
		GAMESTATE.SCORE:
			pass
		_:
			print("No Valid GAMESTATE")

func update_roundstate(state: ROUNDSTATE):
	match state:
		ROUNDSTATE.START:
			pass
		ROUNDSTATE.PLANNING:
			pass
		ROUNDSTATE.ACTING:
			pass
		ROUNDSTATE.END:
			pass
		_:
			print("No Valid ROUNDSTATE")
