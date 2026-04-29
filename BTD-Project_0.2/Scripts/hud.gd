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
    get_tree().call_group("Bunnies", "reset_focus")
    
    $HUD_Shop/HudBgDown/ExitShop.disabled = true
    $HUD_Shop/Shop_Appear.play_backwards("Shop_Appear")
    
    await $HUD_Shop/Shop_Appear.animation_finished
    $HUD_Shop/HudBgDown/BunnySel.texture = null
    
    
func abrir_menu_upgrade(torre_clicada):
    torre_em_foco = torre_clicada
    atualizar_visual_upgrades() # Atualiza as cenouras assim que abre

func _on_path_1_pressed() -> void:
    if torre_em_foco != null:
        torre_em_foco.aplicar_upgrade(1)
        atualizar_visual_upgrades() # Atualiza o visual após o clique

func _on_path_2_pressed() -> void:
    if torre_em_foco != null:
        torre_em_foco.aplicar_upgrade(2)
        atualizar_visual_upgrades() # Atualiza o visual após o clique

# Esta é a função "mágica" que vai gerir os teus ícones
func atualizar_visual_upgrades():
    if torre_em_foco == null: return

    # --- CONFIGURAR PATH 1 ---
    # Nível 1: Disponível se path1 for 0
    $"HUD_Shop/HudBgDown/Upgrade 1-1".disabled = (torre_em_foco.path1 != 0)
    # Nível 2: Disponível se path1 for 1
    $"HUD_Shop/HudBgDown/Upgrade 1-2".disabled = (torre_em_foco.path1 != 1)
    # Nível 3: Disponível se path1 for 2
    $"HUD_Shop/HudBgDown/Upgrade 1-3".disabled = (torre_em_foco.path1 != 2)
    # Nível 4: Disponível se path1 for 3
    $"HUD_Shop/HudBgDown/Upgrade 1-4".disabled = (torre_em_foco.path1 != 3)

    # --- CONFIGURAR PATH 2 ---
    $"HUD_Shop/HudBgDown/Upgrade 2-1".disabled = (torre_em_foco.path2 != 0)
    $"HUD_Shop/HudBgDown/Upgrade 2-2".disabled = (torre_em_foco.path2 != 1)
    $"HUD_Shop/HudBgDown/Upgrade 2-3".disabled = (torre_em_foco.path2 != 2)
    $"HUD_Shop/HudBgDown/Upgrade 2-4".disabled = (torre_em_foco.path2 != 3)

    # --- ATUALIZAR AS CENOURAS (VISUAL) ---
    # Usamos get_node_or_null para evitar o erro de 'null instance' se o nome estiver errado
    var cenouras_p1 = [1, 2, 3, 4]
    for n in cenouras_p1:
        var node = get_node_or_null("HUD_Shop/HudBgDown/Upgrade_1_" + str(n) + "/Carrot")
        if node:
            node.visible = (torre_em_foco.path1 >= n)

    var cenouras_p2 = [1, 2, 3, 4]
    for n in cenouras_p2:
        var node = get_node_or_null("HUD_Shop/HudBgDown/Upgrade_2_" + str(n) + "/Carrot")
        if node:
            node.visible = (torre_em_foco.path2 >= n)

    # --- LÓGICA DE BLOQUEIO (CADEADOS) ---
    if torre_em_foco.path1 >= 3:
        $"HUD_Shop/HudBgDown/Upgrade 2-3".disabled = true
        $"HUD_Shop/HudBgDown/Upgrade 2-4".disabled = true
    
    if torre_em_foco.path2 >= 3:
        $"HUD_Shop/HudBgDown/Upgrade 1-3".disabled = true
        $"HUD_Shop/HudBgDown/Upgrade 1-4".disabled = true




func _on_texture_button_pressed() -> void:
    if torre_em_foco != null:
        torre_em_foco.mudar_skin()
