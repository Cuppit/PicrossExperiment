extends Node

const BASE_SCREEN_WIDTH = 1152
const BASE_SCREEN_HEIGHT = 648

## This enum tracks what 'state' the cell is currently in.
enum CellState {
	OPEN, 
	CARVED, 
	MARKED, 
}

## Tracks what cell state to change cells into while the player is 
## clicking and dagging the mouse across multiple cells.
var last_clicked_state:CellState = CellState.OPEN
