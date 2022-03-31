extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func switch_menu(to_node, from_node):
	var _animation_time = 0.5
	var tween = $Tween
	tween.interpolate_property(
		from_node,
		"rect_position:x",
		from_node.rect_position.x,
		2000,
		_animation_time,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		to_node,
		"rect_position:x",
		to_node.rect_position.x,
		0,
		_animation_time,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_IN_OUT
	)
	
	tween.start()


func _on_Level_Select_pressed():
	switch_menu($"UI/Menus/Level Select Menu", $"UI/Menus/Main Menu")


func _on_Quit_to_Desktop_pressed():
	get_tree().quit()


func _on_Back_to_Main_Menu_pressed():
	switch_menu($"UI/Menus/Main Menu", $"UI/Menus/Level Select Menu")

var switch_to = "res://Menus/Main Menu.tscn"

func play_level(level):
	switch_to = "res://Rooms/Level_" + str(level) + ".tscn"
	var tween = $Tween
	tween.interpolate_property(
		$UI,
		"modulate:a",
		$UI.modulate.a,
		0, # final value
		0.4, # time taken
		tween.TRANS_SINE,
		tween.EASE_IN
	)
	tween.interpolate_property(
		$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera",
		"global_transform:origin",
		$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera".global_transform.origin,
		$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Slime".global_transform.origin,
		1.6, # time taken
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	var original_basis = $"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera".global_transform.basis
	$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera".look_at($"CanvasLayer/ViewportContainer/Viewport/Menu Room/Slime".global_transform.origin, Vector3.UP)
	var basis = $"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera".global_transform.basis
	$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera".global_transform.basis = original_basis
	tween.interpolate_property(
		$"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera",
		"global_transform:basis",
		original_basis,
		basis,
		1.6,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.interpolate_property(
		$CanvasLayer/CanvasModulate,
		"color",
		$CanvasLayer/CanvasModulate.color,
		Color(0.0, 0.0, 0.0), # final_val
		1.2,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	
	tween.start()


func _on_Tween_tween_completed(object, key):
	if object == $"CanvasLayer/ViewportContainer/Viewport/Menu Room/Camera" and key == ":global_transform:origin":
		get_tree().change_scene(switch_to)
