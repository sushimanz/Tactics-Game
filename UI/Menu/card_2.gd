extends Control
var cardHighlighted = true




func _on_texture_rect_mouse_entered():
	$Anim.play("Select")
	cardHighlighted = true


func _on_texture_rect_mouse_exited():
	$Anim.play("Deselect")
	cardHighlighted = false # Replace with function body.


func _on_texture_rect_gui_input(event: InputEvent):
	pass # Replace with function body.
