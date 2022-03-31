extends Spatial


export var timing := 2
onready var tween := $Tween
onready var base_pos := translation.y
onready var height := scale.y


func activate():
	tween.interpolate_property(
		$"Gate Door", 
		"translation:y",
		null,
		base_pos + height,
		timing,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_IN)
	tween.start()

func deactivate():
	tween.interpolate_property(
		$"Gate Door", 
		"translation:y",
		null,
		base_pos,
		timing,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT)
	tween.start()
