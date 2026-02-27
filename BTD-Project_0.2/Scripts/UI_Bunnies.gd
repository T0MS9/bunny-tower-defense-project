extends Node2D

@onready var rookie_scene = preload("res://Scenes/Towers/rookie.tscn")
@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"

var temp_tower = null
# 1. CRIAMOS ESTA MEMÓRIA AQUI NO TOPO
var local_proibido = false 

func _process(_delta: float) -> void:
	# Gestão do Botão
	var moedas_atuais = int(moedas_label.text)
	$Rookie.disabled = (moedas_atuais < 75)

	if temp_tower != null:
		temp_tower.global_position = get_global_mouse_position()
		
		var detector = temp_tower.get_node("HitBox") # Mudaste de Area2D para HitBox
		var areas_em_cima = detector.get_overlapping_areas()
		
		# 2. ATUALIZAMOS A MEMÓRIA
		local_proibido = false
		for area in areas_em_cima:
			print("Estou a tocar na área: ", area.name)
			if area.is_in_group("no_place"):
				local_proibido = true
				break
		
		# Feedback Visual
		if local_proibido:
			temp_tower.modulate = Color(1, 0.2, 0.2, 0.5) # Vermelho
		else:
			temp_tower.modulate = Color(1, 1, 1, 0.5) # Normal
		
		# 3. SÓ DEIXA LARGAR SE NÃO FOR PROIBIDO
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not local_proibido:
				largar_torre()
			else:
				print("Local inválido! A apagar torre...")
				temp_tower.queue_free()
				temp_tower = null

func _on_rookie_button_down() -> void:
	if temp_tower == null and moedas_barra.value >= 75:
		temp_tower = rookie_scene.instantiate()
		temp_tower.modulate.a = 0.5 
		temp_tower.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# 1. DESLIGA O RANGE (para não detetar inimigos enquanto arrastas)
		# Assumindo que o Range está dentro da cena da torre
		var range_node = temp_tower.get_node("Range")
		range_node.monitoring = false
		range_node.monitorable = false
		
		get_tree().current_scene.add_child(temp_tower)

func largar_torre():
	if temp_tower:
		var moedas_atuais = int(moedas_label.text)
		
		if moedas_atuais >= 75: 
			temp_tower.modulate.a = 1.0
			temp_tower.process_mode = Node.PROCESS_MODE_INHERIT
			
			# 2. LIGA O RANGE (agora a torre está fixa e pode atacar)
			var range_node = temp_tower.get_node("Range")
			range_node.monitoring = true
			range_node.monitorable = true
			
			moedas_label.text = str(moedas_atuais - 75)
			temp_tower = null
		else:
			temp_tower.queue_free()
			temp_tower = null
