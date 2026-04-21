extends Node2D

@onready var moedas_node = $HUD / PGB_M

var font = load("res://FontText/Coiny-Regular.ttf")
var font_size = 40
var valor_lucky = 5
var posicionado = false


func _physics_process(_delta):
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
    $Lucky / AnimationPlayer.play("LuckyAction")

func label_money():
    var label_M = Label.new()
    $Panel.add_child(label_M)


    label_M.text = "+" + str(valor_lucky) + "$"



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


func _on_texture_button_pressed() -> void :
    if $Lucky.texture.resource_path == "res://Assets/Bunnies/Lucky.png":
        $Lucky.texture = load("res://Assets/Bunnies/Skins/ZeRon.png")

    elif $Lucky.texture.resource_path == "res://Assets/Bunnies/Skins/ZeRon.png":
        $Lucky.texture = load("res://Assets/Bunnies/Lucky.png")
