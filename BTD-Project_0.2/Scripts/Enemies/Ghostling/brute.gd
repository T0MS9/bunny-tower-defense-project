extends CharacterBody2D

@export var speed = 200
var vida = 5

func _process(delta: float) -> void:
	$"../ProgressBar".value = vida
	
func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio == 1:
		get_tree().call_group("HP", "take_dmg", 1)
		get_parent().queue_free()


func DMGED(quantidade):
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida -= quantidade
	$Brute_TakeDMG.play("Brute_TakeDMG")
	moedas.text = str(valor_atual + 1)
	
	if vida <= 0:
		moedas.text = str(valor_atual + 4)
		speed = 0
		$Brute_TakeDMG.play("Brute_TakeDMG") 
		await $Brute_TakeDMG.animation_finished
		get_parent().queue_free()
