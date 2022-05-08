extends Spatial


export var item_needed = ""
onready var _input_map = load("res://Input Manager.gd").new()
var _is_open = false

func _ready():
	set_process(false)

func _on_Open_Prompt_Area_body_entered(body):
	if body.is_in_group("slime"):
		if body.get_parent().is_in_inventory(item_needed):
			body.get_parent().show_actionbar("Press " + _input_map.get_input_for("interact") + " to open door")
			set_process(true)
		else:
			body.get_parent().show_actionbar("You need a " + item_needed + " to open this door!")


func _process(delta):
	if Input.is_action_just_pressed("interact") and not _is_open:
		_is_open = true
		var tween = $Tween
		tween.interpolate_property(
			$"Door Pivot",
			"rotation_degrees:y",
			$"Door Pivot".rotation_degrees.y,
			90,
			1.5,
			tween.TRANS_SINE,
			tween.EASE_IN
		)
		tween.start()
		$"door open".play()


func _on_Open_Prompt_Area_body_exited(body):
	if body.is_in_group("slime"):
		if body.get_parent().is_in_inventory(item_needed):
			body.get_parent().hide_actionbar("Press " + _input_map.get_input_for("interact") + " to open door")
			set_process(false)
		else:
			body.get_parent().hide_actionbar("You need a " + item_needed + " to open this door!")


func _on_Exit_Area_body_entered(body):
	if body.is_in_group("slime"):
		body.get_parent().level_complete()
