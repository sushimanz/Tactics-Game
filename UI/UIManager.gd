class_name UIManager
extends CanvasLayer

signal _update_mainstate(next_state: Main.MAINSTATE)

var ui_arr: Array[UI]

#Not sure if it will be used, since there might be a better way to push what mainstate is going to happen next
var in_mainstate: Main.MAINSTATE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		#Maybe do something when left button pressed? Idk
		#print("UI Stack: ", ui_arr)
		#print(name, " left mouse click effect!")
		pass
	
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		go_back()

func go_back() -> void:
	if !ui_arr.is_empty():
		var cur_ui: UI = ui_arr[-1]
		
		#Don't want to remove main menu, ever (Except when game starts/is exited)
		if !cur_ui.is_root_ui:
			ui_arr.remove_at(len(ui_arr)-1)
			cur_ui.queue_free()
			print(cur_ui.name, " has been freed")
			
			if !ui_arr.is_empty():
				ui_arr[-1].visible = true
				
				if len(ui_arr) > 1:
					var prev_menu: UI = ui_arr[-2]
					print(prev_menu.name, " is now in focus")
			
		#Will need to change this in the future but for now just goes to main menu by pressing ESC
		#elif main.current_mainstate != Main.MAINSTATE.ENTER_TITLE:
			#main.update_mainstate(Main.MAINSTATE.ENTER_TITLE)
		
		else:
			goto_ui(UIData.are_you_sure_popup_menu)
			#print(
				#"\n*** UIManager _go_back() call ***",
				#"\n\tInvalid ", cur_ui.name, " free attempt",
				#"\n\tThis ui is a root UI!\n"
			#)
	else:
		goto_ui(UIData.are_you_sure_popup_menu)
		#If there are no open menus, open up the game menu
		#This should show the options to quit game or go to desktop and such
		#update_mainstate(Main.MAINSTATE.EXIT_GAME)

func goto_ui(next_scene: PackedScene) -> void:
	var next_ui = next_scene.instantiate()
	
	if next_ui is UI:
		ui_arr.append(next_ui)
		add_child(next_ui)
		if len(ui_arr) > 1:
			if next_ui is not PKPopupMenu:
				ui_arr[-2].visible = false
		#print("UI Array (goto_ui): ", ui_arr)
		
		#Can figure out how to make this better later
		next_ui.update_mainstate.connect(update_mainstate)
		next_ui.go_back.connect(go_back)
		next_ui.goto_ui.connect(goto_ui)
		
	else:
		print(
			"\n*** UIManager goto_ui() call ***",
			"\n\tInvalid UI: ", next_ui.name,
			"\n\tCheck if it extends GUI!\n"
		)
		
		next_ui = null

#Can figure out how to make this better later
func update_mainstate(next_mainstate: Main.MAINSTATE):
	_update_mainstate.emit(next_mainstate)

func clean_menus() -> void:
	ui_arr.clear()
	for child in get_children():
		child.queue_free()
		
	print("All menus have been freed")
