extends Control

const EMPTY = false
const FILLED = true

# Utility flags for hint text generation function 
const COLUMN = true
const ROW = false

var cell = preload("res://scenes/cell/cell.tscn")

## Holds the solution as a 2D array of boolean values. "FILLED" (true) values
## are cells in the grid that are filled in for the solution.
var current_pattern = []

var board = []

# Set to true to start with sample grid
const DEBUG = false


## Reads a text file containing a pattern for processing
func load_from_file(filename:String) -> String:
	var file = FileAccess.open(filename, FileAccess.READ)
	var content = file.get_as_text()
	return content


## TODO: Finish this function
func get_hint_text(col_or_row:bool, idx:int):
	print("GETTING HINT FOR Column?:",col_or_row,".  Index:",idx)
	var nextnum = 0
	var hint_contents = []
	var to_return = ""
	if col_or_row == COLUMN:
		## calculate the hint for the current column
		for cell in range(0,len(current_pattern)):
			print("-  is [",cell,"][",idx,"] carved?:",current_pattern[cell][idx])
			if current_pattern[cell][idx]:
				nextnum += 1
			elif nextnum > 0:
				hint_contents.append(nextnum)
				nextnum=0
				
				
		for num in hint_contents:
			to_return = to_return+str(num)+"\n"
		
		if hint_contents == []:
			to_return += str(nextnum)
		elif nextnum > 0:
			to_return += str(nextnum)
				
	elif col_or_row == ROW:
		for cell in range(0, len(current_pattern[idx])):
			if current_pattern[idx][cell]:
				nextnum += 1
			elif nextnum > 0:
				hint_contents.append(nextnum)
				nextnum=0
				
		for num in hint_contents:
			to_return = to_return+str(num)+" "
		
		if hint_contents == []:
			to_return += str(nextnum)
		elif nextnum > 0:
			to_return += str(nextnum)
	
	#to_return.append(str(nextnum))
	#if hint_contents == []:
	#	to_return = str(nextnum)
	
	if col_or_row == COLUMN:
		print("   ---HINT FOR COLUMN "+str(idx)+" IS: ",to_return)
	return to_return


func setup_grid():
	var pattern = load_from_file("HEARTpattern.txt")
	
	## Used for building the 2D boolean 'current_pattern' which stores the
	## solution
	var curr_row = [] 
	# --Input cleanup--
	var to_filter = ["\r"]
	var to_proc = pattern.split("")
	var x = len(pattern) - 1
	while x >= 0:
		if to_proc[x] in to_filter:
			print("removing: ",x)
			to_proc.remove_at(x)
		x -= 1
	pattern = "".join(to_proc)
	
	var pat_width = len(pattern.split("\n")[0])
	
	## Critically "shaving off" last '\n' for accurate column-counting purposes
	var pat_height = len(pattern.split("\n")) 
	
	print("THE WIDTH OF THIS PATTERN IS: ",len(pattern.split("\n")[0]))
	
	## Set the columns to account for the extra column/row for the hints.
	$GridContainer.columns =  len(pattern.split("\n")[0]) + 1 
	print("THE HEIGHT OF THIS PATTERN IS: ",pat_height)

	
	## Generate the actual gridmap
	
	# Prepare to track the hint label locations 
	var hint_lbl_cols = []
	var hint_lbl_rows = []
	
	# Fill the top-left of the grid with a "dead" cell
	var lbl = Label.new()
	lbl.text = "CORNER"
	$GridContainer.add_child(lbl)
	
	for space in range (0,pat_width):
		lbl = Label.new()
		lbl.text = "COL"
		hint_lbl_cols.append(lbl)
		$GridContainer.add_child(lbl)
		pass
	
	## First row hint goes here; this allows a new label to be added every time
	## a  '\n' is scanned in the pattern during generation below 
	lbl = Label.new()
	lbl.text = "ROW"
	hint_lbl_rows.append(lbl)
	$GridContainer.add_child(lbl)
	
	for c in pattern:
		if c == '\n':
			current_pattern.append(curr_row)
			curr_row = []
			print("new line, adding hint for next row: ")
			lbl = Label.new()
			lbl.text = "ROW"
			hint_lbl_rows.append(lbl)
			$GridContainer.add_child(lbl)
		else:
			if c == 'X':
				curr_row.append(FILLED)
			elif c == 'O':
				curr_row.append(EMPTY)

			var to_add = cell.instantiate()
			to_add.initialize()
			$GridContainer.add_child(to_add)
			to_add.connect("cell_carved", _on_cell_carved)
			
	board = $GridContainer.get_children()
	
	print(pattern.c_unescape().split(""))
	print("SOLUTION GRID: \n",current_pattern)

	# Fill the hint labels with the text for their hints
	for col in range(0, len(hint_lbl_cols)):
		var label:Label = hint_lbl_cols[col]
		label.text = get_hint_text(COLUMN,col)

	## "-1" on length necessary to account for "vestigal" row created as a 
	## side-effect of a badly-designed grid loading method.  Because a
	## plaintext file is used as the loading method, and plaintext files 
	## usually save with a '\n' at the end of them, an extra row is created,
	## causing index problems when trying to calculate the hints for the board.
	for row in range(0, len(hint_lbl_rows)-1):
		var label:Label = hint_lbl_rows[row]
		label.text = get_hint_text(ROW,row)


func _init():
	pass
	
	
func _ready():
	#This 
	if not DEBUG:
		for n in $GridContainer.get_children():
			n.queue_free()
		setup_grid()
	
	else:
		setup_grid()
		pass

# TODO: implement a check for whether the current state of the grid matches the
# pattern of the puzzle here
func _on_cell_carved():
	print("The signal was successfully passed!")
	pass
