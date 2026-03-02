extends Node2D

@onready var rookie_scene = preload("res://Scenes/Towers/rookie.tscn")
@onready var lucky_scene = preload("res://Scenes/Towers/lucky.tscn")

@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"
# Dica: É melhor usar moedas_barra.value em vez de converter o texto sempre
@onready var moedas_atuais = int(moedas_label.text)

var temp_tower = null
var local_proibido = false 
# --- NOVA VARIÁVEL PARA O CUSTO ---
var custo_da_torre_atual = 0


func _process(_delta: float) -> void:
	
	# Atualiza moedas atuais para a verificação dos botões
	moedas_atuais = int(moedas_label.text)
	
	# Gestão do Botão (Atualizado para usar os custos corretos)
	$BoxRookie/Rookie.disabled = (moedas_atuais < 125)
	$BoxRookie.disabled = (moedas_atuais < 125)
	
	$BoxLucky/Lucky.disabled = (moedas_atuais < 200)
	$BoxLucky.disabled = (moedas_atuais < 200)
	
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

func _on_rookie_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 125:
		temp_tower = rookie_scene.instantiate()
		custo_da_torre_atual = 125 # <--- Define o custo aqui
		configurar_torre_temp()

func _on_lucky_button_down() -> void:
	if temp_tower == null and moedas_atuais >= 200:
		temp_tower = lucky_scene.instantiate()
		custo_da_torre_atual = 200 # <--- Define o custo aqui
		configurar_torre_temp()

# Função auxiliar para não repetir código de configuração
func configurar_torre_temp():
	temp_tower.modulate.a = 0.5 
	temp_tower.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var range_node = temp_tower.get_node("Range")
	range_node.monitoring = false
	range_node.monitorable = false
	
	get_tree().current_scene.add_child(temp_tower)

func largar_torre():

	if temp_tower:
		# --- AQUI ESTÁ A ADAPTAÇÃO ---
		# Verifica se ainda temos moedas baseadas no custo definido ao clicar
		if moedas_atuais >= custo_da_torre_atual: 
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
