extends CharacterBody2D

@export var speed = 220
var vida_B = 5

func _process(_delta: float) -> void:
	# 1. Atualiza a barra de vida que está no PathFollow2D (o pai)
	# Usamos o caminho relativo para encontrar o nó da ProgressBar
	if has_node("../ProgressBar"):
		get_node("../ProgressBar").value = vida_B

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	
	if pf:
		pf.progress += speed * delta

		if pf.progress_ratio >= 1.0:
			get_tree().call_group("HP", "take_dmg", 5)
			pf.queue_free()

func _on_button_mouse_entered() -> void:
	var pf = get_parent() as PathFollow2D
	
	# --- BARREIRA DE IMUNIDADE (TÚNEL) ---
	# Se o bicho estiver entre 0.73 e 0.785, o código para aqui
	if pf and pf.progress_ratio >= 0.73 and pf.progress_ratio <= 0.785:
		return # Sai da função imediatamente
	# -------------------------------------

	# 4. LÓGICA DE DANO (Só corre se o bicho NÃO estiver no túnel)
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida_B -= 1
	moedas.text = str(valor_atual + 1)

	$Brute_TakeDMG.play("Brute_TakeDMG")
	
	# 5. LÓGICA DE MORTE
	if vida_B <= 0:
		# Bónus extra por matar o bicho
		moedas.text = str(int(moedas.text) + 4)
		speed = 0 

		$Brute_TakeDMG.play("Brute_TakeDMG")
		await $Brute_TakeDMG.animation_finished
		
		# Apaga o pai (PathFollow2D), o que apaga o bicho e a barra de vida junto
		$"..".queue_free()
