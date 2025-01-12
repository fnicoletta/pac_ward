extends Area3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sphere: CSGSphere3D = $CGSphere3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		sphere.visible = false
		audio_stream_player.play()
		body.update_score()
		if not audio_stream_player.is_connected("finished", Callable(self, "_on_audio_finished")):
			audio_stream_player.connect("finished", Callable(self, "_on_audio_finished").bind(body))

func _on_audio_finished() -> void:
	queue_free()
