class_name UtilityData
extends Resource

static func create_2d_array(width: int, height: int) -> Array:
	var arr: Array
	
	for w in width:
		arr.append([])
		arr[w].resize(height)
	
	return arr

#func create_2d_array(width, height, value):
	#var a = []
#
	#for y in range(height):
		#a.append([])
		#a[y].resize(width)
#
		#for x in range(width):
			#a[y][x] = value
			#
	#return a
