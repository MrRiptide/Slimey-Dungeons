extends Spatial


export var size := 20
export(NodePath) onready var connected_to = get_node(connected_to) as Node

onready var tween := $Tween

var _pressed_height := 0.2
var _anim_time := 0.2
var is_pressed := false


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector3(size, 1, size)


func update():
	var weight = 0
	for body in $Mesh/Area.get_overlapping_bodies():
		if "Slime" in body.name:
			weight += body.size
	
	print(!is_pressed and weight >= size)
	if !is_pressed and weight >= size:
		is_pressed = true
		connected_to.activate()
		tween.interpolate_property(
			$Mesh,
			"scale:y",
			null,
			_pressed_height,
			_anim_time,
			tween.TRANS_SINE,
			# Easing out means we start fast and slow down as we reach the target value.
			tween.EASE_OUT
		)
		tween.start()
	elif is_pressed and weight < size:
		is_pressed = false
		connected_to.deactivate()
		tween.interpolate_property(
			$Mesh,
			"scale:y",
			null,
			1,
			_anim_time,
			tween.TRANS_SINE,
			# Easing out means we start fast and slow down as we reach the target value.
			tween.EASE_OUT
		)
		tween.start()


func _on_Area_body_entered(body):
	update()


func _on_Area_body_exited(body):
	update()
