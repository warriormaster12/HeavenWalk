extends Area



func _on_Killzone_body_entered(body):
	if body.name == "Player": 
		get_tree().reload_current_scene()
