extends Area 

export(AudioStream) var dialogue #Public variable. You can insert a file in to your project in this case insert an audio file


 
func _on_EventTrigger_body_entered(body):
	if body.name == "Player": 	 
		$DialoguePlayer.stream = dialogue 
		$DialoguePlayer.playing = true 
		$CollisionShape.disabled = true  
	