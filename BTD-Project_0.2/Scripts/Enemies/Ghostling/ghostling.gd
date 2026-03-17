extends CharacterBody2D


@export var speed = 200
@export var vida = 1
var speed_base = 200

const slimed = preload("res://Assets/Enemies/Ghostlings/Ghostling_Slimed.png") # OU o teu caminho exacto

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 1)
		get_parent().queue_free()

func gooey_stun(tempo: float):
	$Ghostling.texture = slimed
	speed = speed_base / 3

	await get_tree().create_timer(tempo).timeout

	speed = speed_base
	desaparecer_gosma()

func desaparecer_gosma():
	var sprite_gosma = get_node_or_null("GosmaEmCima")
	
	if sprite_gosma:
		sprite_gosma.queue_free()

func DMGED(quantidade):
	vida -= quantidade
	
	if vida <= 0:
		var moedas = get_tree().current_scene.find_child("Moedas")
		var valor_atual = int(moedas.text)
		moedas.text = str(valor_atual + 1)
		
		
		speed = 0 
		set_physics_process(false) 
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		await $AnimationPlayer.animation_finished
		get_parent().queue_free()
