extends Node

# Aqui dizemos ao Godot onde estão as tuas imagens
var cursor_point = load("res://Assets/Sprites/Others/UI/Others/CursorPoint.png")
var cursor_pressed = load("res://Assets/Sprites/Others/UI/Others/CursorPressed.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_point)



func _input(event):
	# Verifica se carregaste no botão do rato
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Quando carregas, muda para o ícone de 'Pressed'
				Input.set_custom_mouse_cursor(cursor_pressed)
			else:
				# Quando soltas, volta para o ícone de 'Point'
				Input.set_custom_mouse_cursor(cursor_point)
