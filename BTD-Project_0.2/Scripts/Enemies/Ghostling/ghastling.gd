extends CharacterBody2D

@export var speed = 350

func _physics_process(delta):
	
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta


	if $"..".progress_ratio == 1:
		get_tree().call_group("HP", "take_dmg", 1)
		$"..".queue_free()

func _on_button_mouse_entered() -> void:
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	
	moedas.text = str(valor_atual + 1)
	$"..".queue_free()
