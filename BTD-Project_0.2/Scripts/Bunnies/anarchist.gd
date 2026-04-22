extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var balas = 5
var dmg_Anarchist = 2



func _process(delta: float) -> void :
    var spawner = get_tree().get_first_node_in_group("spawner")

    if balas <= 0:
        if spawner.ronda_a_decorrer:
            $Reload.paused = false
            if $Reload.is_stopped():
                $Reload.start()
                pronto_para_atacar = false
        else:
            $Reload.paused = true

    $ProgressBar.max_value = $Reload.wait_time
    $ProgressBar.value = $Reload.wait_time - $Reload.time_left
    $ProgressBar.visible = balas <= 0


    if $Timer.is_stopped() and $Reload.is_stopped() and balas > 0 and spawner.ronda_a_decorrer:
        pronto_para_atacar = true
    else:
        pronto_para_atacar = false

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
        break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Anarchist/AnimationPlayer.play("Anarchist_Attack")
        alvo.DMGED(dmg_Anarchist)
        pronto_para_atacar = false
        
        balas -= 1
        print("Balas restantes: ", balas)

        $Timer.start()

func _on_reload_timeout() -> void :
    balas = 5
    pronto_para_atacar = false



func _draw() -> void :
    if mostrar_range:
        var shape = $Range / CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range / CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()
