#class_name Cell
extends TextureButton

signal cell_carved

const DEBUG_INVIS_BUTTON = false

const MOD_COLOR_OPEN = Color(1,1,1,1)
const MOD_COLOR_CARVED = Color(0.33,0,0,1)
const MOD_COLOR_MARKED = Color(0.86,1.55,1.33,1.00)



## Soft import from the Global script of the "state" enum
const CellState = Global.CellState

var last_state = Global.last_clicked_state

## Indicates whether this cell is a filled cell or not.
@export var filled = false

func _init(fill:bool = false):
	filled = fill


func initialize(fill:bool = false):
	filled = fill


## The current 'state' setting of the cell (by default is "OPEN").
var current_cell_state:Global.CellState = CellState.OPEN:
	set(new_cell_state):
		if new_cell_state == CellState.OPEN:
			modulate = MOD_COLOR_OPEN
		elif new_cell_state == CellState.CARVED:
			modulate = MOD_COLOR_CARVED
			if current_cell_state != CellState.CARVED:
				cell_carved.emit()
		elif new_cell_state == CellState.MARKED:
			modulate = MOD_COLOR_MARKED
		Global.last_clicked_state = new_cell_state
		current_cell_state = new_cell_state 


func _on_pressed():
	pass

'''
func _on_gui_input(event):

	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				print("left button clicked")
				if (current_cell_state == CellState.CARVED):
					current_cell_state = CellState.OPEN
				else:
					current_cell_state = CellState.CARVED
			MOUSE_BUTTON_RIGHT:
				if current_cell_state == CellState.MARKED:
					current_cell_state = CellState.OPEN
				else:
					current_cell_state = CellState.MARKED
	'''
func _on_gui_input(event):
	if Input.is_action_just_pressed("carve"):
		proc_carve_action()
	elif Input.is_action_just_pressed("mark"):
		proc_mark_action()

func proc_carve_action():
	if DEBUG_INVIS_BUTTON:
		visible = false
	if (current_cell_state == CellState.CARVED):
		current_cell_state = CellState.OPEN
	else:
			print("Carve action occurred")
			current_cell_state = CellState.CARVED
				


func proc_mark_action():
		if current_cell_state == CellState.MARKED:
			current_cell_state = CellState.OPEN
		else:
			current_cell_state = CellState.MARKED
'''
func _on_mouse_entered():
	if Input.is_action_pressed("carve"):
			print("carve key pressed")
			if (current_cell_state == CellState.CARVED):
				current_cell_state = CellState.OPEN
			else:
					current_cell_state = CellState.CARVED
	elif Input.is_action_pressed("mark"):
			if current_cell_state == CellState.MARKED:
				current_cell_state = CellState.OPEN
			else:
				current_cell_state = CellState.MARKED		
'''
func _on_mouse_entered():

	if Input.is_action_pressed("carve") or Input.is_action_pressed("mark"):
		current_cell_state = Global.last_clicked_state
		
