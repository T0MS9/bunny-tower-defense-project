extends Node2D

@onready var rookie_scene = preload("res://Scenes/Towers/rookie.tscn")
# Usamos @onready para garantir que o nó existe quando o jogo começa
@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"


var temp_tower = null 

func _process(_delta: float) -> void:
	var moedas_atuais = int(moedas_label.text)
	
	if moedas_atuais < 75:
		$Rookie.disabled = true
	else:
		$Rookie.disabled = false
	
	
	if temp_tower != null:
		temp_tower.global_position = get_global_mouse_position()
		
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			largar_torre()

func _on_rookie_button_down() -> void:
	# 1. Verificamos o valor da barra de mana (PGB_M)
	if temp_tower == null and moedas_barra.value >= 75:
		temp_tower = rookie_scene.instantiate()
		temp_tower.modulate.a = 0.5 
		
		temp_tower.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().current_scene.add_child(temp_tower)

func largar_torre():
	if temp_tower:
		# 2. Atualizamos o valor das moedas LENDO o texto atual do Label
		var moedas_atuais = int(moedas_label.text)
		
		if moedas_atuais >= 1: # Só gasta se tiver dinheiro
			temp_tower.modulate.a = 1.0
			
			moedas_label.text = str(moedas_atuais - 75)
			temp_tower.process_mode = Node.PROCESS_MODE_INHERIT
			# Se quiseres tirar mana também:
			# barra_mana.value -= 75
			temp_tower = null
		else:
			# Se afinal não tinha dinheiro, apaga a torre "fantasma"
			temp_tower.queue_free()
			temp_tower = null
