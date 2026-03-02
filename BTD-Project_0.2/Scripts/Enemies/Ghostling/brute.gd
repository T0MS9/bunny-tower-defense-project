extends CharacterBody2D

@export var speed = 200
var vida = 5

func _process(delta: float) -> void:
	# Atualiza a tua barra de vida visual
	$"../ProgressBar".value = vida
	
func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio >= 0.99: # Mais seguro que == 1
		perder_vida_base()

func perder_vida_base():
	# 1. Encontra o teu nó de UI de moedas e HP
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	# 2. Perde a vida no jogo (chamando o teu grupo "HP")
	get_tree().call_group("HP", "take_dmg", 1)
	
	# 3. GANHAS MOEDAS POR PERDER VIDA
	moedas.text = str(valor_atual + 1)
	
	# 4. Apaga o inimigo
	get_parent().queue_free()

func DMGED(quantidade):
	# Encontra o nó de moedas na cena principal
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida -= quantidade
	$Brute_TakeDMG.play("Brute_TakeDMG")
	
	# --- RECOMPENSA POR HIT ---
	# Ganha 1 moeda a cada hit, independente do dano
	moedas.text = str(valor_atual + quantidade)
	
	if vida <= 0:
		# --- RECOMPENSA POR MORTE ---
		# Já ganhou 1 no hit acima, adiciona +4 para totalizar 5
		var novo_total = int(moedas.text)
		moedas.text = str(novo_total + 5)
		
		# Lógica de morte
		speed = 0
		set_physics_process(false) 
		$Brute_TakeDMG.play("Brute_TakeDMG") 
		await $Brute_TakeDMG.animation_finished
		
		get_parent().queue_free()
