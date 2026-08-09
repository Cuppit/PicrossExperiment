extends Control

@onready var zoom_lvl_ind = $CanvasLayer/ZoomLevelIndicator


func _ready():
	$PlayerCamera.zoom_level_adjusted.connect(_on_zoom_level_adjusted)
	#$connect("zoom_level_adjusted", _on_zoom_level_adjusted)
	

func _on_zoom_level_adjusted():
	zoom_lvl_ind.text = "ZOOM LEVEL: "+str($PlayerCamera.zoom)+"\
		\nX-DIM: "+"\
		\n-USE THE MOUSE WHEEL TO ZOOM IN/OUT"+"\
		\n-GUESS THE PATTERN USING NUMBER
		\n HINTS IN MARGINS 
		\n-LEFT-CLICK TO \"CARVE\" A SPACE\
		\n-RIGHT-CLICK TO MARK A SPACE AS 
		\n \"NOT CARVED\" 
		\n NOTHING CURRENTLY HAPPENS WHEN
		\n SOLVED"
		
