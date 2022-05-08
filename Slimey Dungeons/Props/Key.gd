extends Spatial


func _on_Area_body_entered(body):
	if body.is_in_group("slime"):
		$"collect key sfx".play()
		body.get_parent().get_key()
		visible = false
		$Key/Area/CollisionShape.disabled = true


func _process(delta):
	rotation_degrees.y = wrapf(rotation_degrees.y + 30*delta, 0, 360)
