extends Spatial


func _on_Area_body_entered(body):
	if body.is_in_group("slime"):
		if body.get_parent().get_child_count() <= 1:
			body.get_parent().level_failed()
		var parent = body.get_parent()
		if body == parent.get_focused():
			parent.focus_slime(parent.get_child(posmod(parent.selected_slime.get_index() - 2, parent.get_child_count())))
		body.queue_free()
