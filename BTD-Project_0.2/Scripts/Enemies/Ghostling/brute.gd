extends CharacterBody2D

@export var speed = 200
var vida = 5
	
func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta


#codigo q perder vidas quando chega ao fim (NGM)
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 5)
		get_parent().queue_free()

func DMGED(quantidade):
	# Encontra o nó de moedas na cena principal
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida -= quantidade
	$AnimationPlayer.play("Animations/ghostling_TakeDMG")
	
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
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		await $AnimationPlayer.animation_finished
		get_parent().queue_free()
