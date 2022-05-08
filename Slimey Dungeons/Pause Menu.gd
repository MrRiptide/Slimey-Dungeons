extends Control

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and not get_node("../Level End Display").visible:
		visible = !visible
		if (visible):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = !get_tree().paused


func _on_Quit_Button_pressed():
	get_tree().quit()


func _on_Main_Menu_Button_pressed():
	get_tree().change_scene("res://Menus/Main Menu.tscn")
	get_tree().paused = false
