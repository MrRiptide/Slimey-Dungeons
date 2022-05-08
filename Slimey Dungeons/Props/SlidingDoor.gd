extends Spatial


export var timing := 2
export var signals_needed := 1
onready var tween := $Tween
onready var base_pos = $"Gate Door".translation.y
onready var height = $"Gate Door".scale.y

var active_signals = []

func activate_signal(signal_id):
	if not active_signals.has(signal_id):
		active_signals.append(signal_id)
	
	update()

func deactivate_signal(signal_id):
	if active_signals.has(signal_id):
		active_signals.remove(signal_id)
	
	update()

func update():
	if active_signals.size() >= signals_needed:
		tween.interpolate_property(
			$"Gate Door", 
			"translation:y",
			$"Gate Door".translation.y,
			4,
			timing,
			tween.TRANS_SINE,
			# Easing out means we start fast and slow down as we reach the target value.
			tween.EASE_IN)
	else:
		tween.interpolate_property(
			$"Gate Door", 
			"translation:y",
			$"Gate Door".translation.y,
			0,
			timing,
			tween.TRANS_SINE,
			# Easing out means we start fast and slow down as we reach the target value.
			tween.EASE_OUT)
	tween.start()

func set_color(color):
	var mat = $Gem.get_surface_material(0).duplicate()
	mat.albedo_color = color
	$Gem.set_surface_material(0, mat)
	
