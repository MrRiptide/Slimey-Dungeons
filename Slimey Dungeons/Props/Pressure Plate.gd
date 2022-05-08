extends Spatial


export var size := 20
export(NodePath) onready var connected_to = get_node(connected_to) as Node
export var color := Color(1,1,1,1)
export var signal_id := "pressure_plate"

onready var tween := $Tween

var _pressed_height := 0.2
var _anim_time := 0.5
var is_pressed := false


# Called when the node enters the scene tree for the first time.
func _ready():
	#scale = Vector3(size, size, size)
	var material = $Mesh.get_surface_material(0).duplicate()
	material.albedo_color = color
	$Mesh.set_surface_material(0, material)
	connected_to.set_color(color)
	$"Mesh/Viewport/Size Label".text = str(size)


func update():
	var weight = 0
	for body in $Mesh/Area.get_overlapping_bodies():
		if body.is_in_group("weighted"):
			weight += body.size
	
	if !is_pressed and weight >= size:
		is_pressed = true
		connected_to.activate_signal(signal_id)
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
		$"activate sfx".play()
	elif is_pressed and weight < size:
		is_pressed = false
		connected_to.deactivate_signal(signal_id)
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
