extends Control

@onready var zoom_lvl_ind = $CanvasLayer/ZoomLevelIndicator


func _ready():
	$PlayerCamera.zoom_level_adjusted.connect(_on_zoom_level_adjusted)
	#$connect("zoom_level_adjusted", _on_zoom_level_adjusted)
	

func _on_zoom_level_adjusted():
	zoom_lvl_ind.text = "ZOOM LEVEL: "+str($PlayerCamera.zoom)+"\
		\nX-DIM: "+""
