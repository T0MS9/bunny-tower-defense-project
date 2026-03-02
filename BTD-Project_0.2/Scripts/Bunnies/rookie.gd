extends Node2D

var mostrar_range = false
var dmg_Rookie = 1

var preco_upgrade_1 = 400
var preco_upgrade_2 = 500

# Usamos @onready para encontrar os nós assim que o jogo começa
@onready var moedas_label = get_tree().current_scene.find_child("Moedas", true, false)
@onready var moedas_barra = get_tree().current_scene.find_child("PGB_M", true, false)

func _process(_delta: float) -> void:
	if moedas_label:
		# Lemos o valor real que está no texto do Label a cada frame
		var valor_venda = int(moedas_label.text)
		
		# Ativa/Desativa botões baseados no dinheiro real
		$Button.disabled = (valor_venda < preco_upgrade_1)
		$Button2.disabled = (valor_venda < preco_upgrade_2)

# --- FUNÇÕES DE COMPRA ---

func _on_button_pressed() -> void:
	var valor_venda = int(moedas_label.text) # Check final antes de comprar
	
	if valor_venda >= preco_upgrade_1:
		# 1. Subtrai o dinheiro e atualiza a UI
		var novo_valor = valor_venda - preco_upgrade_1
		moedas_label.text = str(novo_valor)
		if moedas_barra: moedas_barra.value = novo_valor
		
		# 2. Aplica o Upgrade
		dmg_Rookie = 3
		$Timer.wait_time = 1
		$Rookie.texture = load("res://Assets/Bunnies/Paths/Rookie01.png")
		$Button.disabled = true
		$Button2.disabled = true

func _on_button_2_pressed() -> void:
	var valor_venda = int(moedas_label.text)
	
	if valor_venda >= preco_upgrade_2:
		# 1. Subtrai o dinheiro e atualiza a UI
		var novo_valor = valor_venda - preco_upgrade_2
		moedas_label.text = str(novo_valor)
		if moedas_barra: moedas_barra.value = novo_valor
		
		# 2. Aplica o Upgrade
		$Timer.wait_time = 0.2
		dmg_Rookie = 1
		$Rookie.texture = load("res://Assets/Bunnies/Paths/Rookie02.png")



# --- RESTO DO TEU CÓDIGO (DRAW E ATAQUE) ---

func _draw() -> void:
	if mostrar_range:
		var shape = $Range/CollisionRange.shape
		if shape is CircleShape2D:
			var raio_final = shape.radius * $Range/CollisionRange.scale.x
			draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void:
	mostrar_range = true
	queue_redraw()

func _on_button_mouse_exited() -> void:
	mostrar_range = false
	queue_redraw()

func _on_timer_timeout() -> void:
	var corpos = $Range.get_overlapping_bodies()
	for corpo in corpos:
		if corpo.is_in_group("Ghostlings"):
			atacar(corpo)

func atacar(alvo):
	if alvo.has_method("DMGED"):
		$Rookie/AnimationPlayer.play("RookieAttack")
		alvo.DMGED(dmg_Rookie)











#func _on_button_pressed() -> void:
	#dmg_Rookie = 3
	#$Timer.wait_time = 1
	#$Rookie.texture = load("res://Assets/Bunnies/Paths/Rookie01.png")
#
#
#func _on_button_2_pressed() -> void:
	#$Timer.wait_time = 0.2
	#dmg_Rookie = 1
	#$Rookie.texture = load("res://Assets/Bunnies/Paths/Rookie02.png")
