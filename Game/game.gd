extends Node2D

const Unit = preload("res://Game/Unit.tscn")
var units: Array = []


func _ready() -> void:
	if Multiplayer.is_host:
		_host_join()

func _host_join() -> void:
	$MultiplayerSpawner.spawn_function = add_player
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			$MultiplayerSpawner.spawn(pid)
	)
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())

func add_player(pid):
	var uni = Unit.instantiate()
	uni.name = str(pid)
	$TileMapLayer.add_child(uni)
	#uni.global_position = $TileMapLayer.get_child(units.size()).global_position
	units.append(uni)
	
	return uni
