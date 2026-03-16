extends CharacterBody2D

@export var speed = 200
@export var vida = 10
var speed_base = 200 

const GOSMA_SPRITE = preload("res://Assets/Others/Abilities & Utilities/GooAttack.png")


func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

#codigo q perder vidas quando chega ao fim (NGM)
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 15)
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


func gooey_stun(tempo: float):
		# 1. PARAR O FANTASMA
		speed = speed_base / 2
		# 2. APARECER A GOSMA EM CIMA (image_0.png)
		aparecer_gosma()

		# 3. ESPERAR O TEMPO PASSAR
		await get_tree().create_timer(tempo).timeout

		# 4. VOLTAR AO NORMAL
		print("GHOSTLING ESTÁ LIVRE DA GOSMA!")
		speed = speed_base # Devolve a velocidade original
		desaparecer_gosma()

# --- FUNÇÕES PARA A GOSMA (VISUAIS) ---
func aparecer_gosma():
	# Cria um novo nó de Sprite2D
	var sprite_gosma = Sprite2D.new()
	
	# Dá-lhe a textura da tua imagem
	sprite_gosma.texture = GOSMA_SPRITE
	
	# Dá-lhe um nome para o podermos apagar depois
	sprite_gosma.name = "GosmaEmCima"
	
	# Posiciona-o um pouco acima do fantasma
	sprite_gosma.position = Vector2(0, -50)
	
	# Adiciona-o como filho deste fantasma
	add_child(sprite_gosma)

func desaparecer_gosma():
	# Procura se existe um filho chamado "GosmaEmCima"
	var sprite_gosma = get_node_or_null("GosmaEmCima")
	
	# Se existir, apaga-o
	if sprite_gosma:
		sprite_gosma.queue_free()
