extends Node2D

#Easy Ghostlings
@onready var Ghostling = preload("res://Scenes/Enemies/Ghostling/ghostling.tscn")
@onready var Ghazt = preload("res://Scenes/Enemies/Ghostling/ghazt.tscn")
@onready var Ghoul = preload("res://Scenes/Enemies/Ghostling/ghoul.tscn")
@onready var Ghaztling = preload("res://Scenes/Enemies/Ghostling/ghaztling.tscn")

#Hard Ghostlings
@onready var Brute = preload("res://Scenes/Enemies/Ghostling/brute.tscn")

#Undead Ghostlings
@onready var Undead_Ghostling = preload("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn")

var rodada_atual = 1
var inimigos_vivos = 0
var vaga_atual = []
var ronda_a_decorrer = false



func _process(_delta):
	var botao_start = get_tree().get_first_node_in_group("start_button")
	
	if botao_start:
		if inimigos_vivos > 0 or not $Timer.is_stopped():
			botao_start.disabled = true
		else:
			botao_start.disabled = false


func iniciar_vaga():
	ronda_a_decorrer = true
	
	var lucky = get_tree().get_first_node_in_group("Lucky_script")
	lucky.time_start()
	
	match rodada_atual:
		1:
			vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
		2:
			vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
		3:
			vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghazt, Ghazt, Ghazt]
		4:
			vaga_atual = [Ghostling, Ghostling, Ghoul, Ghostling, Ghazt, Ghoul]
		5:
			vaga_atual = [Ghazt, Ghazt, Ghazt, Ghoul, Ghaztling, Ghaztling, Ghaztling]
		6:
			vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghazt, Ghazt, Brute]
		7:
			vaga_atual = [Ghoul, Ghoul, Ghazt, Ghaztling, Ghaztling, Ghoul, Ghoul]
		8:
			vaga_atual = [Brute, Brute, Ghaztling, Ghaztling, Ghaztling, Ghoul]
		9:
			vaga_atual = [Ghazt, Ghazt, Ghostling, Brute, Brute, Brute, Ghoul, Ghoul, Ghazt, Ghaztling, Ghaztling, Ghaztling]
		10:
			vaga_atual = [Brute, Ghaztling, Brute, Ghaztling, Brute, Brute, Brute, Brute]

	$Timer.start()


func _on_timer_timeout():
	if vaga_atual.size() > 0:
		# 1. Tira o primeiro inimigo da fila
		var cena_do_inimigo = vaga_atual.pop_front() 
		
		# 2. Cria o inimigo
		var novo_fantasma = cena_do_inimigo.instantiate()
		get_node("../Path2D").add_child(novo_fantasma)
		
		# 3. Contagem
		inimigos_vivos += 1
	else:
		$Timer.stop()


func inimigo_morreu():
	inimigos_vivos -= 1
	
	if inimigos_vivos < 0:
		inimigos_vivos = 0
		
	print("Inimigos no mapa: ", inimigos_vivos)
	
	if vaga_atual.size() == 0 and inimigos_vivos == 0 and ronda_a_decorrer:
		ronda_a_decorrer = false
		
		var lucky = get_tree().get_first_node_in_group("Lucky_script")
		lucky.time_stop()
		
		rodada_atual += 1
		atualizar_contador_rondas()
		
		var moedas_no = get_tree().current_scene.find_child("Moedas")
		if moedas_no:
			moedas_no.text = str(int(moedas_no.text) + 50 + rodada_atual - 1)

func atualizar_contador_rondas() -> void:
	var contador_no = get_tree().get_first_node_in_group("Round_Counter")
	contador_no.text = str(rodada_atual)
