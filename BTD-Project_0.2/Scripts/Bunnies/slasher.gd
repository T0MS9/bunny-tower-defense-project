extends Node2D

var pronto_para_atacar = false
var mostrar_range = false
var contagem_ult = 0
var dmg_Slasher = 3




func _process(delta: float) -> void :
    $ProgressBar.value = contagem_ult
    $ProgressBar / ProgressBar.value = contagem_ult

    if $Timer.is_stopped():
        pronto_para_atacar = true


    if pronto_para_atacar == true:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    if contagem_ult >= 20:
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
    else:
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
            break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        # Animações básicas de ataque
        $Slasher/AnimationPlayer.play("LuckyAction")
        $SlasherAttackEffect.play("default")
        $SlasherAttack.play("default")
        
        $Slash.play()
        
        contagem_ult += 3
        verificar_ult()

        # LÓGICA DE DANO
        if contagem_ult >= 20:
            # ULTIMATE ATIVA: Dano massivo (aumentei de 2 para 3)
            alvo.DMGED(dmg_Slasher * 2) 
            print("Contagem de Ult: ", contagem_ult)
            $Slash_Ult.play()
            
            
            if contagem_ult >= 35: 
                alvo.DMGED(dmg_Slasher * 2) 
                
                contagem_ult = 0
                verificar_ult()
        else:
            alvo.DMGED(dmg_Slasher)
            print("Contagem de Ult: ", contagem_ult)

        pronto_para_atacar = false
        $Timer.start()

func verificar_ult():
    # Agora a condição de desligar é 60, dando mais "janela" de uso
    if contagem_ult >= 35 or contagem_ult == 0:
        print("A Ult Resetou... ", contagem_ult)
        $Slasher/Ult.visible = false
        $Slasher/AppearUlt.play_backwards("default")
        

    elif contagem_ult > 20:
        if not $Slasher/Ult.visible and not $Slasher/AppearUlt.is_playing():
            $Slasher/AppearUlt.play("default")
            await $Slasher/AppearUlt.animation_finished
            $Slasher/Ult.visible = true
            $Slasher/Ult.play("default")



func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range / CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_insp_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()
