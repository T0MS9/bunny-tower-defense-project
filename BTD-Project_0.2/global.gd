extends Node

# Aqui dizemos ao Godot onde estão as tuas imagens
var cursor_point = load("res://Assets/Others/Others/CursorPoint.png")
var cursor_pressed = load("res://Assets/Others/Others/CursorPressed.png")
# Verifica se carregaste no botão do rato

func _input(event):
	if event.is_action_pressed("fullscreen_key"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
# Quando carregas, muda para o ícone de 'Pressed'
				Input.set_custom_mouse_cursor(cursor_pressed)
			else:
				# Quando soltas, volta para o ícone de 'Point'
				Input.set_custom_mouse_cursor(cursor_point)
