extends Button


func _on_toggled(toggled_on: bool) -> void:
	$"../StartGame_Sound".play()
