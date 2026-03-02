extends Node2D

@onready var moedas_node = $HUD/PGB_M 

func _on_timer_timeout() -> void:
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	moedas.text = str(valor_atual + 5)
	$Lucky/AnimationPlayer.play("LuckyAction")
