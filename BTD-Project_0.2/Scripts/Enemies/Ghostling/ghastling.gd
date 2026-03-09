extends CharacterBody2D

@export var speed = 550
@export var vida = 1

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta
	
#codigo q perder vidas quando chega ao fim (NGM)
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 3)
		get_parent().queue_free()


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
