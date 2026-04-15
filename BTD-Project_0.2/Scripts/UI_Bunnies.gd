extends Node2D

@onready var rookie_scene = preload("res://Scenes/Towers/rookie.tscn")
@onready var lucky_scene = preload("res://Scenes/Towers/lucky.tscn")
@onready var slasher_scene = preload("res://Scenes/Towers/slasher.tscn")
@onready var gooey_scene = preload("res://Scenes/Towers/gooey.tscn")


@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"
# Dica: É melhor usar moedas_barra.value em vez de converter o texto sempre
@onready var moedas_atuais = int(moedas_label.text)

#só para o Lucky e talvez o 
var tipo_torre_atual = ""

var temp_tower = null
var local_proibido = false 
var custo_da_torre_atual = 0


func _process(_delta: float) -> void:
	
	# Atualiza moedas atuais para a verificação dos botões
	moedas_atuais = int(moedas_label.text)
	
	# Gestão do Botão (Atualizado para usar os custos corretos)
	$ScrollContainer/GridContainer/Rookie_BG_dps.disabled = (moedas_atuais < 75)
	$ScrollContainer/GridContainer/Rookie_BG_dps/Rookie.disabled = (moedas_atuais < 75)
	
	$ScrollContainer/GridContainer/Lucky_BG_support.disabled = (moedas_atuais < 130)
	$ScrollContainer/GridContainer/Lucky_BG_support/Lucky.disabled = (moedas_atuais < 130)
	
	$ScrollContainer/GridContainer/Slasher_BG_dps.disabled = (moedas_atuais < 140)
	$ScrollContainer/GridContainer/Slasher_BG_dps/Slasher.disabled = (moedas_atuais < 140)
	
	$ScrollContainer/GridContainer/Gooey_BG_stun.disabled = (moedas_atuais < 90)
	$ScrollContainer/GridContainer/Gooey_BG_stun/Gooey.disabled = (moedas_atuais < 90)
	
	if temp_tower != null:
		temp_tower.global_position = get_global_mouse_position()
		
		var detector = temp_tower.get_node("HitBox")
		var areas_em_cima = detector.get_overlapping_areas()
		
		local_proibido = false
		for area in areas_em_cima:
			if area.is_in_group("no_place"):
				local_proibido = true
				break
		
		# Feedback Visual
		if local_proibido:
			temp_tower.modulate = Color(1, 0.2, 0.2, 0.5) # Vermelho
		else:
			temp_tower.modulate = Color(1, 1, 1, 0.5) # Normal
		
		# 3. Lógica para Largar ou Cancelar
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not local_proibido:
				largar_torre()
			else:
				# Cancelou em local proibido, apaga a torre
				temp_tower.queue_free()
				temp_tower = null
				custo_da_torre_atual = 0


#Config dos botões dos Bunnies
#///////////////////////////////////////////////////////////////

func _on_rookie_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 75:
		temp_tower = rookie_scene.instantiate()
		custo_da_torre_atual = 75 # <--- Define o custo aqui
		configurar_torre_temp()
		
func _on_slasher_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 140:
		temp_tower = slasher_scene.instantiate()
		custo_da_torre_atual = 140 # <--- Define o custo aqui
		configurar_torre_temp()

func _on_lucky_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 130:
		tipo_torre_atual = "lucky"
		temp_tower = lucky_scene.instantiate()
		custo_da_torre_atual = 130 # <--- Define o custo aqui
		configurar_torre_temp()
		
func _on_gooey_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 90:
		tipo_torre_atual = "gooey"
		temp_tower = gooey_scene.instantiate()
		custo_da_torre_atual = 90 # <--- Define o custo aqui
		configurar_torre_temp()
	
#///////////////////////////////////////////////////////////////

# Função auxiliar para não repetir código de configuração
func configurar_torre_temp():
	temp_tower.modulate.a = 0.5 
	temp_tower.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var range_node = temp_tower.get_node("Range")
	range_node.monitoring = false
	range_node.monitorable = false
	
	get_tree().current_scene.add_child(temp_tower)
#temp_tower.get_node("Timer").start()
func largar_torre():
	var spawner = get_tree().get_first_node_in_group("spawner")
	var lucky = get_tree().get_first_node_in_group("Lucky_script")
	
	if tipo_torre_atual == "lucky":
		
		if spawner.ronda_a_decorrer:
			lucky.posicionado = true
			temp_tower.get_node("Timer").start()
		else:
			lucky.posicionado = true
			temp_tower.get_node("Timer").stop()
			
	if temp_tower:
		# --- AQUI ESTÁ A ADAPTAÇÃO ---
		# Verifica se ainda temos moedas baseadas no custo definido ao clicar
		if moedas_atuais >= custo_da_torre_atual:
			temp_tower.get_node("Shadow").visible = true
			temp_tower.modulate.a = 1.0
			temp_tower.process_mode = Node.PROCESS_MODE_INHERIT
			
			# 2. LIGA O RANGE
			var range_node = temp_tower.get_node("Range")
			range_node.monitoring = true
			range_node.monitorable = true
			
			# Subtrai o custo correto
			var novas_moedas = moedas_atuais - custo_da_torre_atual
			moedas_label.text = str(novas_moedas)
			moedas_barra.value = novas_moedas # Atualiza a barra tmb
			
			range_node.get_node("CollisionRange").visible = true
			
			# Reset
			temp_tower = null
			custo_da_torre_atual = 0
		else:
			# Não tem moedas suficientes no momento de largar
			temp_tower.queue_free()
			temp_tower = null
			custo_da_torre_atual = 0
