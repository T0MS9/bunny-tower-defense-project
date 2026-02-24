extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map_1.tscn")


var SettingsUP = false
func _on_settings_pressed() -> void:
	$MainMenu_Left/Buttons/Start.disabled = true
	
	if SettingsUP == false:
		$Options/Settings_Anim.play("Settings_Anim")
		SettingsUP = true


func _on_exit_menu_pressed() -> void:
	if SettingsUP == true:
		$Options/Settings_Anim.play_backwards("Settings_Anim")
		await $Options/Settings_Anim.animation_finished
		
		$MainMenu_Left/Buttons/Start.disabled = false
		
		SettingsUP = false



func _on_settings_mouse_entered() -> void:
	$MainMenu_Left/Settings.modulate = Color(1.211, 1.211, 1.211)
	
func _on_settings_mouse_exited() -> void:
	$MainMenu_Left/Settings.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
func _on_bestiario_mouse_entered() -> void:
	$MainMenu_Left/Bestiario.modulate = Color(1.211, 1.211, 1.211)
	
func _on_bestiario_mouse_exited() -> void:
	$MainMenu_Left/Bestiario.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_achievements_mouse_entered() -> void:
	$MainMenu_Left/Achievements.modulate = Color(1.211, 1.211, 1.211)

func _on_achievements_mouse_exited() -> void:
	$MainMenu_Left/Achievements.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	
	
	
func _on_exit_pressed() -> void:
	$MainMenu_Left/Buttons/BIG_Start.disabled = true
	$MainMenu_Left/Buttons/Voltar.disabled = true
	$StartGame_Sound.play()
	$Camera2D/MenuGoLeft.play("MenuGoLeft")
	
	await $Camera2D/MenuGoLeft.animation_finished
	$MainMenu_Left/Buttons/BIG_Start.disabled = false
	$MainMenu_Left/Buttons/Voltar.disabled = false
	
func _on_voltar_pressed() -> void:
	$Camera2D/MenuGoLeft.play_backwards("MenuGoLeft")
	$MainMenu_Left/Buttons/Voltar.disabled = true
	
	
func _on_easter_egg_pressed() -> void:
	$"MainMenu_Left/SillyBunny/easter egg".disabled = true
	$MainMenu_Left/SillyBunny/Squeaky.play()
	
	$MainMenu_Left/SillyBunny/AnimationPlayer.play("Squeaky")
	await $MainMenu_Left/SillyBunny/AnimationPlayer.animation_finished
	
	$"MainMenu_Left/SillyBunny/easter egg".disabled = false
