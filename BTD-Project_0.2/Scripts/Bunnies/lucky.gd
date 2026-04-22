extends Node2D

@onready var moedas_node = $HUD / PGB_M

var font = load("res://FontText/Coiny-Regular.ttf")
var font_size = 40
var valor_lucky = 5
var posicionado = false

var focus = false
var skin = false

func _physics_process(_delta):
    
    if focus == true:
        $ArrowSupport.visible = true
    else:
        $ArrowSupport.visible = false
    
    $ProgressBar.max_value = $Timer.wait_time
    $ProgressBar.value = $Timer.wait_time - $Timer.time_left


    var spawner = get_tree().get_first_node_in_group("spawner")

    if not spawner.ronda_a_decorrer or not posicionado:
        $Timer.paused = true
    else:
        $Timer.paused = false

        if $Timer.is_stopped():
            $Timer.start()


func _on_timer_timeout() -> void :
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    moedas.text = str(valor_atual + valor_lucky)
    $Lucky/AnimationPlayer.play("LuckyAction")

func label_money():
    var label_M = Label.new()
    $Panel.add_child(label_M)


    label_M.text = "RESENHA AVERIGUADA"



    if $Lucky.texture.resource_path == "res://Assets/Bunnies/Lucky.png":
        label_M.modulate = Color(1.0, 0.902, 0.392, 1.0)

    elif $Lucky.texture.resource_path == "res://Assets/Bunnies/Skins/ZeRon.png":
        label_M.modulate = Color(0.957, 0.478, 0.965, 1.0)


    label_M.add_theme_font_override("font", font)
    label_M.add_theme_font_size_override("font_size", 40)

    label_M.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.341))
    label_M.add_theme_constant_override("shadow_offset_x", 3)
    label_M.add_theme_constant_override("shadow_offset_y", 3)
    label_M.add_theme_constant_override("shadow_outline_size", 9)


    var x_aleatorio = randf_range(0, 200)
    var y_aleatorio = randf_range(0, 150)
    label_M.position = Vector2(x_aleatorio, y_aleatorio)


    var tween = create_tween()
    tween.tween_property(label_M, "modulate:a", 0.0, 1.0)
    tween.parallel().tween_property(label_M, "position:y", label_M.position.y - 20, 1.0)

    tween.finished.connect(label_M.queue_free)

func time_stop():
    $Timer.stop()

func time_start():
    $Timer.start()


func reset_focus():
    focus = false

func mudar_skin():
    skin = !skin
    
    var path = $Lucky.texture.resource_path
    match path:
        "res://Assets/Bunnies/Lucky.png":
            $Lucky.texture = load("res://Assets/Bunnies/Skins/ZeRon.png")
            
        "res://Assets/Bunnies/Skins/ZeRon.png":
            $Lucky.texture = load("res://Assets/Bunnies/Lucky.png")
            
        "res://Assets/Bunnies/Paths/Lucky01.png":
            $Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon01.png")
            
        "res://Assets/Bunnies/Skins/Paths/ZeRon01.png":
            $Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky01.png")
            
        "res://Assets/Bunnies/Paths/Lucky02.png":
            $Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon02.png")
            
        "res://Assets/Bunnies/Skins/Paths/ZeRon02.png":
            $Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky02.png")

func _on_button_button_down() -> void:
    # 1. Diz a TODOS os nós no grupo "Bunnies" para correrem a função reset_focus
    get_tree().call_group("Bunnies", "reset_focus")
    
    # 2. Agora liga o foco apenas DESTE coelho
    focus = true
    
    # ... resto do teu código (abrir HUD, etc) ...
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Lucky.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func aplicar_upgrade(caminho: int):
    if caminho == 1:
        
        if skin:
            $Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon01.png")
        else:
            $Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky01.png")
        
    elif caminho == 2:

        if skin:
            $Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon02.png")
        else:
            $Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky02.png")
