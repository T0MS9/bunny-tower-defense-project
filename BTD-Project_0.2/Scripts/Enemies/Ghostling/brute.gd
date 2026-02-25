# extends CharacterBody2D

# @export var speed = 220
# var vida_B = 5 


# func DMGED(quantidade):
# 	# 1. Verifica a barreira de imunidade (Túnel)
# 	# Assim o Rookie também não consegue bater nele se ele estiver escondido!
# 	var pf = get_parent() as PathFollow2D
# 	if pf and pf.progress_ratio >= 0.73 and pf.progress_ratio <= 0.785:
# 		return 

# 	# 2. Retira vida e toca a animação de levar dano
# 	vida_B -= quantidade
# 	$Brute_TakeDMG.play("Brute_TakeDMG")
	
# 	# 3. Dá uma moeda por cada soco (opcional, como no mouse_entered)
# 	var moedas = get_tree().current_scene.find_child("Moedas")
# 	if moedas:
# 		moedas.text = str(int(moedas.text) + 1)

# 	# 4. Verifica se morreu
# 	if vida_B <= 0:
# 		morrer_brute(moedas)


# func morrer_brute(moedas):
# 	speed = 0 
# 	moedas.text = str(int(moedas.text) + 4)
	
# 	$Brute_TakeDMG.play("Brute_TakeDMG") 
# 	await $Brute_TakeDMG.animation_finished
# 	get_parent().queue_free()








extends CharacterBody2D

@export var speed = 200
@export var vida = 1

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio == 1:
		get_tree().call_group("HP", "take_dmg", 1)
		get_parent().queue_free()


func DMGED(quantidade):
	vida -= quantidade
	
	if vida <= 0:
		var moedas = get_tree().current_scene.find_child("Moedas")
		var valor_atual = int(moedas.text)
		moedas.text = str(valor_atual + 1)
		get_parent().queue_free()


func _on_button_mouse_entered() -> void:
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	moedas.text = str(valor_atual + 1)
	get_parent().queue_free()
