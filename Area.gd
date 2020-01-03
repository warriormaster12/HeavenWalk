extends Area


func _on_Area_body_entered(body):
	if body.name == "Master":
		$Test.playing = true
	