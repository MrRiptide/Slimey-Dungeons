extends Spatial


export var item_needed = ""
onready var _input_map = load("res://Input Manager.gd").new()

func _ready():
	set_process(false)

func _on_Open_Prompt_Area_body_entered(body):
	if "Slime" in body.name:
		if body.get_parent().is_in_inventory(item_needed):
			print(_input_map.get_input_for("interact"))
			body.get_parent().show_actionbar("Press " + _input_map.get_input_for("interact") + " to open door")
		else:
			body.get_parent().show_actionbar("You need a " + item_needed + " to open this door!")
		set_process(true)


func _process(delta):
	if Input.is_action_just_pressed("interact"):
		var tween = $Tween
		tween.interpolate_property(
			$"Door Pivot",
			"rotation_degrees:y",
			$"Door Pivot".rotation_degrees.y,
			90,
			3,
			tween.TRANS_SINE,
			tween.EASE_IN
		)
		tween.start()


func _on_Open_Prompt_Area_body_exited(body):
	if "Slime" in body.name:
		if body.get_parent().is_in_inventory(item_needed):
			body.get_parent().hide_actionbar("Press " + _input_map.get_input_for("interact") + " to open door")
		else:
			body.get_parent().hide_actionbar("You need the right key to open this door!")
		set_process(false)


func _on_Exit_Area_body_entered(body):
	if "Slime" in body.name:
		body.get_parent().level_complete()
