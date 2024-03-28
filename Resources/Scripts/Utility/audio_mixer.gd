extends Node


func change_audio_level(mixer_name: String, audiolevel: float) -> void:
	#print(audiolevel)
	#print(linear_to_db(audiolevel))
	print(mixer_name + " bus value changed")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(mixer_name), linear_to_db(audiolevel))
	#print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(mixer_name)))
