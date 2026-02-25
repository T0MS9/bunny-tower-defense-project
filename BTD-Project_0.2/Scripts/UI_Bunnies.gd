extends Node2D

# Arrastamos o ficheiro .tscn da torre para aqui
var torre_rookie = preload("res://Scenes/Towers/rookie.tscn") 
var torre_fantasma = null

func _process(_delta):
	if torre_fantasma:
		# Faz a torre seguir o rato no mapa
		torre_fantasma.global_position = get_global_mouse_position()
		
		# Se clicar, ela fixa no chão
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			largar_torre()

func _on_rookie_button_down():
	# Quando carregas no botão do Rookie dentro do menu Bunnies
	if torre_fantasma == null:
		torre_fantasma = torre_rookie.instantiate()
		torre_fantasma.modulate.a = 0.5 # Transparente
		# Adiciona ao mapa principal
		get_tree().current_scene.add_child(torre_fantasma)

func largar_torre():
	torre_fantasma.modulate.a = 1.0
	torre_fantasma = null
