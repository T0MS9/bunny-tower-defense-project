extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var TimeSlimed = 3.0

func _process(delta: float) -> void :
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()

    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
            break

func atacar(alvo):
    if alvo.has_method("gooey_stun"):
        $Gooey / AnimationPlayer.play("Gooey_Attack")

        alvo.gooey_stun(TimeSlimed)

        pronto_para_atacar = false
        $Timer.start()


func _draw() -> void :
    if mostrar_range:
        var shape = $Range / CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range / CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_insp_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()
