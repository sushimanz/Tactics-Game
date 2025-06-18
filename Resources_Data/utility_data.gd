class_name UtilityData
extends Resource
##Utility data. Contains static functions, such as create_2d_array, and (should contain) other utilitarian functions

##Creates a 2D array, given width and height, in that order (Minimum int input = 1)
static func create_2d_array(width: int = 1, height: int = 1) -> Array[Array]:
	if width < 1:
		width = 1
		push_error("Improper width set for 2D Array")
	if height < 1:
		height = 1
		push_error("Improper height set for 2D Array")
	
	var arr: Array[Array]
	
	for w in width:
		arr.append([])
		arr[w].resize(height)
	
	return arr
