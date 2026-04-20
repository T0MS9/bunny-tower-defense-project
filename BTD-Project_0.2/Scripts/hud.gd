extends Node2D

@onready var spawner = get_node("../../GhostlingSpawner")

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



func _on_button_pressed() -> void :
    $"Options".visible = true
    $Pause.visible = false




func _on_continue_pressed():
    $"Options".visible = false
    $Pause.visible = true

func _on_options_pressed():
    $PauseMenu.visible = false
    $Options.visible = true



func _on_back_menu_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")



func _on_exit_settings_pressed() -> void :
    $"Options".visible = false
    $Pause.visible = true


func _on_restart_pressed() -> void :
    get_tree().reload_current_scene()


func _on_start_round_pressed() -> void :
    spawner.iniciar_vaga()
