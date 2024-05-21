extends Node2D
var is_button_pressed = false
var step_time = 0.0
var matrix = [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]]

signal cell_change(column, row, new_value)

func _ready():
	pass # Replace with function body.

func new_life_cell(matrix, i, j):
	var count = 0
	var l = [[i - 1, j - 1], [i, j - 1], [i + 1, j - 1],
		 [i - 1, j], [i + 1, j],
		 [i - 1, j + 1], [i, j + 1], [i + 1, j + 1]]
	for el in l:
		if (el[0] != -1) and (el[1] != -1):
			if (el[0] != (len(matrix[0]))) and (el[1] != len(matrix)):
				if matrix[el[0]][el[1]] == 1:
					count += 1
	if count == 3:
		return [i, j]
	return 0

func new_dead_cell(matrix, i, j):
	var count = 0
	var l = [[i - 1, j - 1], [i, j - 1], [i + 1, j - 1],
		 [i - 1, j], [i + 1, j],
		 [i - 1, j + 1], [i, j + 1], [i + 1, j + 1]]
	for el in l:
		if (el[0] != -1) and (el[1] != -1):
			if (el[0] != len(matrix[0])) and (el[1] != len(matrix)):
				if matrix[el[0]][el[1]] == 1:
					count += 1
	if count not in [2, 3]:
		return [i, j]
	return 0

func _process(delta):
	if is_button_pressed:
		if step_time >= 1:
			
			var list_new_life_cells = []
			var list_new_dead_cells = []
			for i in range(len(matrix)):
				for j in range(len(matrix[i])):
					if matrix[i][j] == 0:
						list_new_life_cells.append(new_life_cell(matrix, i, j))
					if matrix[i][j] == 1:
						list_new_dead_cells.append(new_dead_cell(matrix, i, j))
			for i in list_new_life_cells:
				if typeof(i) != 2:
					matrix[i[0]][i[1]] = 1
					cell_change.emit(i[1], i[0], 1)
			for i in list_new_dead_cells:
				if typeof(i) != 2:
					matrix[i[0]][i[1]] = 0
					cell_change.emit(i[1], i[0], 0)
			
			step_time = 0.0
		else:
			step_time += delta



func _on_button_toggled(button_pressed):
	if button_pressed:
		is_button_pressed = true
	else:
		is_button_pressed = false
		step_time = 0.0


func _on_simple_circle_button_position_button(x, y):
	var column = (x-354) / 49
	var row = (y-90) / 49
	if matrix[row][column] == 0:
		matrix[row][column] = 1
		cell_change.emit(column, row, 1)
	else:
		matrix[row][column] = 0
		cell_change.emit(column, row, 0)


func _on_cell_change(column, row, new_value):
	var button = get_node("row_buttons_"+str(row+1)+"/simple_circle_button"+str(column+1)+"/texture")
	button.visible = true if new_value == 1 else false
