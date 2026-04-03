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

var rodada_atual = 0
var inimigos_vivos = 0
var vaga_atual = []


# Assumindo que o HUD e o Spawner são "irmãos" dentro do Mapa
@onready var start_round: TextureButton = get_node("../HUD/UI_Selection/StartRound")

func _process(_delta):
	# Verificamos se o botão existe antes de mexer nele (boa prática!)
	if start_round and inimigos_vivos == 0 and $Timer.is_stopped():
		start_round.disabled = false

# --- ESTA FUNÇÃO DEVE SER CHAMADA PELO TEU BOTÃO START ---
func iniciar_vaga():
	match rodada_atual:
		1:
			vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
		2:
			vaga_atual = [Ghostling, Ghazt, Ghostling, Ghazt, Brute]
		3:
			vaga_atual = [Brute, Brute, Ghazt, Ghazt, Ghostling]
	
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
		print(inimigos_vivos)
	else:
		# 4. A fila acabou!
		$Timer.stop()
		rodada_atual += 1
		print("Todos os inimigos da rodada foram enviados!")


func inimigo_morreu():
	inimigos_vivos -= 1
	print(inimigos_vivos)


































#extends Node2D
#
##Easy Ghostlings
#@onready var Ghostling = preload("res://Scenes/Enemies/Ghostling/ghostling.tscn")
#@onready var Ghazt = preload("res://Scenes/Enemies/Ghostling/ghazt.tscn")
#@onready var Ghoul = preload("res://Scenes/Enemies/Ghostling/ghoul.tscn")
#@onready var Ghaztling = preload("res://Scenes/Enemies/Ghostling/ghaztling.tscn")
#
##Hard Ghostlings
#@onready var Brute = preload("res://Scenes/Enemies/Ghostling/brute.tscn")
#
##Undead Ghostlings
#@onready var Undead_Ghostling = preload("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn")
#
#var inimigos_criados = 0  # Contador: começa em 0
#var inimigos_vivos = 0
#var rodada_atual = 1
#
#func _process(delta: float) -> void:
	#if inimigos_vivos == 0:
		#$HUD/UI_Selection/StartRound.disable = false
#
#
#func _on_timer_timeout():
	#if rodada_atual == 1:
		#if inimigos_criados < 5:
#
			#var novo_fantasma = Ghostling.instantiate()
			#inimigos_vivos =+ 1
			#get_node("../Path2D").add_child(novo_fantasma)
#
			#inimigos_criados += 1
			#print("Inimigo número: ", inimigos_criados)
		#else:
			#$Timer.stop()
			#rodada_atual += 1
			#inimigos_criados = 0
			#print("Rodada 1 Terminada! O spawner parou.")
			#
	#if rodada_atual == 2:
		#if inimigos_criados < 10:
#
			#var novo_fantasma = Ghostling.instantiate()
			#inimigos_vivos =+ 1
			#get_node("../Path2D").add_child(novo_fantasma)
#
			#inimigos_criados += 1
			#print("Inimigo número: ", inimigos_criados)
		#else:
			#$Timer.stop()
			#rodada_atual += 1
			#inimigos_criados = 0
			#print("Rodada 2 Terminada! O spawner parou.")
