extends CharacterBody2D

@export var speed = 250

var vida_B = 5

func _process(delta: float) -> void:
	$"../ProgressBar".value = vida_B

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta


	if $"..".progress_ratio == 1:
		get_tree().call_group("HP", "take_dmg", 1)
		$"..".queue_free()

func _on_button_mouse_entered() -> void:
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida_B = vida_B - 1
	moedas.text = str(valor_atual + 1)
	$Brute_TakeDMG.play("Brute_TakeDMG")
	
	if vida_B <= 0:

		moedas.text = str(valor_atual + 4)
		$"..".queue_free()
