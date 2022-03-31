extends MeshInstance


func _on_Area_body_entered(body):
	if "Slime" in body.name:
		body.get_parent().get_key()
		get_parent().remove_child(self)
