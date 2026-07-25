extends Camera2D

## Used to eliminate unnecessary micro-adjustments
const MICRO_ADJ_THRESHOLD = 0.001
const ZOOM_INC = 0.2
const ZOOM_MIN = 0.5
const ZOOM_MAX = 2.0

## Signal for tracking adjustments
signal zoom_level_adjusted

## Tracks whether the camera is currently moving with the mouse
var pan_and_tilt_mode = false

var speed = 2
var speed_zoom: float:
	get:
		return speed*2

## Holds the vector indicating the cameras position relative to the mouse
## pointer.  While pan/tilting, the camera wants to maintain this 
## relative distance.
var pan_and_tilt_offset = Vector2()

var target_pos = Vector2()

var target_zoom_lvl:Vector2 = Vector2(1.0, 1.0)



func _ready():
	pass
	## Automatically center the camera in the center of the viewport to start
	position.x=get_viewport().size.x/2
	position.y=get_viewport().size.y/2


func _process(delta):
	# self.position
	if pan_and_tilt_mode:
		target_pos = get_global_mouse_position() - pan_and_tilt_offset
		position = position.lerp(target_pos, speed_zoom*delta)
		position = position.clamp(Vector2(0, 0), Vector2(Global.BASE_MAP_WIDTH, Global.BASE_MAP_HEIGHT))
	if target_zoom_lvl.distance_to(zoom) > MICRO_ADJ_THRESHOLD:
		zoom = zoom.lerp(target_zoom_lvl, speed_zoom*delta)
		zoom_level_adjusted.emit()
			
			
func _input(event):
	if event.is_action_pressed("pan_and_tilt_switch"):
		print("RIGHT CLICK PRESSED IN CAMERA!!!")

		pan_and_tilt_mode = true
		pan_and_tilt_offset = get_global_mouse_position()-position

	elif event.is_action_released("pan_and_tilt_switch"):
		pan_and_tilt_mode = false
		
	if event.is_action_pressed("zoom_in"):
		target_zoom_lvl = target_zoom_lvl+Vector2(ZOOM_INC,ZOOM_INC)
		target_zoom_lvl = target_zoom_lvl.clamp(Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))
	
	if event.is_action_pressed("zoom_out"):
		target_zoom_lvl = target_zoom_lvl-Vector2(ZOOM_INC,ZOOM_INC)
		target_zoom_lvl = target_zoom_lvl.clamp(Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))
