extends CharacterBody2D

@export var speed = 210
var vida = 2
	
func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio >= 0.99:
		perder_vida_base()

func perder_vida_base():
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)

	get_tree().call_group("HP", "take_dmg", 1)
	
	moedas.text = str(valor_atual + 1)

	get_parent().queue_free()

func DMGED(quantidade):
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida -= quantidade
	$AnimationPlayer.play("Animations/ghostling_TakeDMG")

	moedas.text = str(valor_atual + quantidade)
	
	if vida <= 0:
		var novo_total = int(moedas.text)
		moedas.text = str(novo_total + 1)
		
		speed = 0
		set_physics_process(false) 
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		await $AnimationPlayer.animation_finished
		get_parent().queue_free()
