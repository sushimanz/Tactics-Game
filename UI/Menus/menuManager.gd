class_name MenuManager
extends Control

signal _update_mainstate(next_state: Main.MAINSTATE)

var menu_arr: Array[Menu]

#Not sure if it will be used, since there might be a better way to push what mainstate is going to happen next
var in_mainstate: Main.MAINSTATE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#Maybe do something when left button pressed? Idk
		print("Menu Array: ", menu_arr)
		#print(name, " left mouse click effect!")
		pass
	
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		go_back()

func go_back() -> void:
	if !menu_arr.is_empty():
		var cur_menu: Menu = menu_arr[-1]
		
		#Don't want to remove main menu, ever (Except when game starts/is exited)
		if !cur_menu.is_root_ui:
			menu_arr.remove_at(len(menu_arr)-1)
			cur_menu.queue_free()
			print(cur_menu.name, " has been freed")
			
			if !menu_arr.is_empty():
				menu_arr[-1].visible = true
				
				if len(menu_arr) > 1:
					var prev_menu: Menu = menu_arr[-2]
					print(prev_menu.name, " is now in focus")
			
		#Will need to change this in the future but for now just goes to main menu by pressing ESC
		#elif main.current_mainstate != Main.MAINSTATE.ENTER_TITLE:
			#main.update_mainstate(Main.MAINSTATE.ENTER_TITLE)
		
		else:
			goto_menu(MenuData.are_you_sure_popup_menu)
			#print(
				#"\n*** MenuManager _go_back() call ***",
				#"\n\tInvalid ", cur_menu.name, " free attempt",
				#"\n\tThis menu is a root UI!\n"
			#)

func goto_menu(next_scene: PackedScene) -> void:
	var next_menu = next_scene.instantiate()
	
	if next_menu is Menu:
		menu_arr.append(next_menu)
		add_child(next_menu)
		if len(menu_arr) > 1:
			if next_menu is not PKPopupMenu:
				menu_arr[-2].visible = false
		#print("Menu Array (goto_menu): ", menu_arr)
		
		#Can figure out how to make this better later
		next_menu._update_mainstate.connect(update_ms)
		next_menu._go_back.connect(go_back)
		next_menu._goto_menu.connect(goto_menu)
		
	else:
		print(
			"\n*** MenuManager goto_menu() call ***",
			"\n\tInvalid Menu: ", next_menu.name,
			"\n\tCheck if it extends Menu!\n"
		)
		
		next_menu = null

#Can figure out how to make this better later
func update_ms(next_mainstate: Main.MAINSTATE):
	_update_mainstate.emit(next_mainstate)

func clean_menus() -> void:
	menu_arr.clear()
	for child in get_children():
		child.queue_free()
		
	print("All menus have been freed")
