extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

#Main Menu botões
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map_1.tscn")

var SettingsUP = false
func _on_settings_pressed() -> void:
	
	
	$MainMenu_Left/Buttons/Start.disabled = true
	$MainMenu_Left/Buttons/Start.disabled = true
	$MainMenu_Left/Buttons/Exit.disabled = true
	
	if SettingsUP == false:
		$Options/Settings_Anim.play("Settings_Anim")
		SettingsUP = true

func _on_exit_menu_pressed() -> void:
	if SettingsUP == true:
		$Options/Settings_Anim.play_backwards("Settings_Anim")
		await $Options/Settings_Anim.animation_finished
		
		$MainMenu_Left/Buttons/Start.disabled = false
		$MainMenu_Left/Buttons/Settings.disabled = false
		$MainMenu_Left/Buttons/Exit.disabled = false
		
		SettingsUP = false

func _on_exit_pressed() -> void:
	$StartGame_Sound.play()
	$Camera2D/AnimationPlayer.play("MenuGoLeft")
	#get_tree().quit()
	


func _on_settings_mouse_entered() -> void:
	$MainMenu_Left/Settings.modulate = Color(1.211, 1.211, 1.211)
