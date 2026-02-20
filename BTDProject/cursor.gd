extends Node

var cursor_point = load("res://Assets/Sprites/Others/UI/Others/CursorPoint.png")
var cursor_pressed = load("res://Assets/Sprites/Others/UI/Others/CursorPressed.png")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Input.set_custom_mouse_cursor(cursor_pressed)
			else:
				Input.set_custom_mouse_cursor(cursor_point)

# Primeiro codigo em godot woah que foda, jesus woah, que fixe, damn, tô teso. Baza rivals
