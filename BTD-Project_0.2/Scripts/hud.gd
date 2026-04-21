extends Node2D

@onready var spawner = get_node("../../GhostlingSpawner")
var torre_em_foco = null

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


func _on_exit_settings_button_down() -> void:
    
    var focus = get_tree().get_first_node_in_group("Focus")
    if focus.focus:
        focus.focus = false
    
    $HUD_Shop/HudBgDown/ExitShop.disabled = true
    $HUD_Shop/Shop_Appear.play_backwards("Shop_Appear")
    
    await $HUD_Shop/Shop_Appear.animation_finished
    $HUD_Shop/HudBgDown/BunnySel.texture = null
    
    
func abrir_menu_upgrade(torre_clicada):
    torre_em_foco = torre_clicada
    
    # Usar get_node_or_null evita que o jogo feche se o nome estiver mal escrito
    var label_dano = get_node_or_null("HUD_Shop/TextoDano")
    if label_dano:
        label_dano.text = "Dano Atual: " + str(torre_em_foco.dmg_Rookie)
    else:
        print("Aviso: Nó TextoDano não encontrado no HUD!")


func _on_path_1_pressed() -> void:
    if torre_em_foco != null:
        torre_em_foco.aplicar_upgrade(1)


func _on_path_2_pressed() -> void:
    if torre_em_foco != null:
        torre_em_foco.aplicar_upgrade(2)
