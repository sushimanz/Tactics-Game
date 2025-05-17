extends LineEdit

signal new_valid_input(in_valid: int)

var valid_input: String = ""
var min_int: int = 1
var max_int: int = 99

func _on_text_changed(new_text: String) -> void:
	_handle_input(new_text)

func _on_text_submitted(new_text: String) -> void:
	_handle_input(new_text)
	text = valid_input

func _on_focus_exited() -> void:
	text = valid_input

func _handle_input(new_text: String) -> void:
	#print("Text Changed for ", name)
	#print("Text: ", new_text)
	
	if (new_text.length() <= 3) and (new_text.is_valid_int() or new_text == ""):
		if int(new_text) > max_int:
			new_text = str(max_int)
			#text = new_text
		elif int(new_text) < min_int:
			new_text = str(min_int)
			#text = new_text
			
		#print("Valid Input")
		#text = new_text
		if new_text != valid_input:
			valid_input = new_text
			emit_signal("new_valid_input", int(valid_input))
	else:
		#print("Invalid Input")
		text = valid_input
		select(0, text.length())
