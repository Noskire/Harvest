extends AudioStreamPlayer

func _ready():
	get_node("Timer").start()

func _on_timeout():
	self.play()

func _on_AudioStreamPlayer_finished():
	get_node("Timer").start()
