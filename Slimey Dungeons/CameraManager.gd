extends Spatial

# Lower cap for the `_zoom_level`.
export var min_zoom := 40.0
# Upper cap for the `_zoom_level`.
export var max_zoom := 70.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 3.0
# Duration of the zoom's tween animation.
export var zoom_duration := 0.2
export var tips = ""

export var current_level = -1

# The camera's target zoom level.
var _zoom_level := 70.0 setget _set_zoom_level

# We store a reference to the scene's tween node.
onready var tween: Tween = $Camera/Tween


func _ready():
	tween.interpolate_property(
		$"HUD/Game Start Cover",
		"modulate:a",
		$"HUD/Game Start Cover".modulate.a,
		0,
		1.0,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()
	if Global.show_hints:
		$HUD/Tips.text = tips

func _process(delta):
	if is_instance_valid(get_node("../Slimes").selected_slime):
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(get_node("../Slimes").selected_slime.global_transform.origin, 0.7)
	

func _set_zoom_level(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	tween.interpolate_property(
		$Camera,
		"fov",
		$Camera.fov,
		_zoom_level,
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()

func _unhandled_input(event):
	if event.is_action_pressed("control_zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("control_zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)


func level_complete():
	var level_end_display = get_node("HUD/Level End Display")
	if current_level == 15:
		level_end_display.get_node("VBoxContainer/Next Level Container").visible = false
	level_end_display.get_node("VBoxContainer/Label Container/Label").text = "Level " + str(current_level) + " Complete!"
	_level_end()

func level_failed():
	get_node("HUD/Level End Display/VBoxContainer/Label Container/Label").text = "Level " + str(current_level) + " Failed"
	_level_end()


func _level_end():
	get_tree().paused = true
	var level_end_display = get_node("HUD/Level End Display")
	level_end_display.visible = true
	tween.interpolate_property(
		level_end_display,
		"modulate:a",
		level_end_display.modulate.a,
		1,
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_Next_Level_Button_pressed():
	get_tree().change_scene("res://Rooms/Level_" + str(current_level+1) + ".tscn")
	get_tree().paused = false


func _on_Level_Select_Button_pressed():
	Global.menu_mode = "Level Select"
	get_tree().paused = false
	get_tree().change_scene("res://Menus/Main Menu.tscn")


func _replay_level():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Replay_Level_Button_pressed():
	_replay_level()

func _on_Resume_Button_pressed():
	$"HUD/Pause Menu".visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Restart_Level_Button_pressed():
	_replay_level()


func _on_Tween_tween_completed(object, key):
	if object == $"HUD/Game Start Cover":
		object.visible = false
