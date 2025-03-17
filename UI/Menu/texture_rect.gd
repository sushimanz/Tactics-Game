extends TextureRect


var startPosition
var cardHighlighted = true
# Called when the node enters the scene tree for the first time.




func _on_mouse_entered():
	$Anim.play("Select")
	cardHighlighted = true


func _on_mouse_exited():
	$Anim.play("Deselect")
	cardHighlighted = false
	 # Replace with function body.


func _on_gui_input(event):
	pass
