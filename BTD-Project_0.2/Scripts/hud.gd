extends Node2D


func take_dmg(dmg):
	$PGB_V.value -= dmg
	
	if $PGB_V.value == 0:
		$GameOver.visible = true
		$Pause.visible = false


func _process(delta: float):
	if $Options.visible || $GameOver.visible == true:
		get_tree().paused = true
		
	else:
		get_tree().paused = false


#Botão Pausa
func _on_button_pressed() -> void:
	$"Options".visible = true
	$Pause.visible = false



#Botões do Menu Pausa
func _on_continue_pressed():
	$"Options".visible = false
	$Pause.visible = true

func _on_options_pressed():
	$PauseMenu.visible = false
	$Options.visible = true


#Voltar pro Menu (Pausa e GameOver)
func _on_back_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


#Botão das Definições da Pausa
func _on_exit_menu_pressed() -> void:
	$"Options".visible = false
	$Pause.visible = true
	
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


var HUD_is_Up = false
func _on_sigminha_pressed() -> void:
	if HUD_is_Up == false:
		$HUD_Shop/Shop_Appear.play("Shop_Appear")
		HUD_is_Up = true
	
	else:
		$HUD_Shop/Shop_Appear.play_backwards("Shop_Appear")
		HUD_is_Up = false


func _on_attack_pressed() -> void:
	$"../Rookie/AnimationPlayer".play("bunny_attack")
