extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options




#função que inicia junto com o scrpit (mete as options invisiveis e o main menu visivel)
#func _ready():
	#$Buttons.visible = true
	#$Options.visible = false
	

#Main Menu botões
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map_1.tscn")

var SettingsUP = false

func _on_settings_pressed() -> void:
	$StartGame_Sound.play()
	if SettingsUP == false:
		$Options/Settings_Anim.play("Settings_Anim")
		SettingsUP = true

func _on_exit_menu_pressed() -> void:
	if SettingsUP == true:
		$Options/Settings_Anim.play_backwards("Settings_Anim")
		SettingsUP = false

func _on_exit_pressed() -> void:
	$StartGame_Sound.play()
	get_tree().quit()
