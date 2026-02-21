extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

#Main Menu botões
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map_1.tscn")

var SettingsUP = false
func _on_settings_pressed() -> void:
	$StartGame_Sound.play()
	
	$Buttons/Start.disabled = true
	$Buttons/Settings.disabled = true
	$Buttons/Exit.disabled = true
	
	if SettingsUP == false:
		$Options/Settings_Anim.play("Settings_Anim")
		SettingsUP = true

func _on_exit_menu_pressed() -> void:
	if SettingsUP == true:
		$Options/Settings_Anim.play_backwards("Settings_Anim")
		await $Options/Settings_Anim.animation_finished
		
		$Buttons/Start.disabled = false
		$Buttons/Settings.disabled = false
		$Buttons/Exit.disabled = false
		
		SettingsUP = false

func _on_exit_pressed() -> void:
	$StartGame_Sound.play()
	get_tree().quit()
	
