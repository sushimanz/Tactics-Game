extends TileMapLayer

var tokens: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"

func _ready() -> void:
	pass

func start() -> void:
	tokens = get_children()

func startRound() -> void:
	var check: bool
	for token in tokens:
		var test = token.tickUpdate(tick)
		if !test:
			if !check:
				check = test
	tick += 1

func _on_button_pressed() -> void:
	tokens = get_children()
	tick = 0
	tTimer.start()


func _on_tick_timer_timeout() -> void:
	startRound()
