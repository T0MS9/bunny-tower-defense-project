extends Node2D

var mostrar_range = false
var pronto_para_atacar = false
var TimeSlimed = 3.0

var focus = false
var skin = false

func _process(delta: float) -> void :
    
    if focus == true:
        $ArrowStun.visible = true
    else:
        $ArrowStun.visible = false
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()

    for corpo in corpos:
        if corpo.is_in_group("Hitbox_Goo"):
            atacar(corpo)
            break

func atacar(alvo):
    if alvo.has_method("gooey_stun"):
        $Gooey/AnimationPlayer.play("Gooey_Attack")
        
        # 1. Lista de nós de áudio
        var sons_hit = [$Goo, $Goo2]
        
        # 2. Sorteia um dos sons
        var som_sorteado = sons_hit[randi() % sons_hit.size()]
        
        # 3. Aplica um pitch aleatório antes de tocar
        # Para sons viscosos (goo), um pitch mais baixo costuma soar melhor
        som_sorteado.pitch_scale = randf_range(0.8, 1.0)
        
        # 4. Toca o som escolhido com o novo pitch
        som_sorteado.play()
        
        alvo.gooey_stun(TimeSlimed)
        pronto_para_atacar = false
        $Timer.start()


func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range / CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()
    
    
func reset_focus():
    focus = false

func mudar_skin():
    skin = !skin
    
    var path = $Gooey.texture.resource_path
    match path:
        "res://Assets/Bunnies/Gooey.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Void.png")
            
        "res://Assets/Bunnies/Skins/Void.png":
            $Gooey.texture = load("res://Assets/Bunnies/Gooey.png")
            
        "res://Assets/Bunnies/Paths/Gooey01.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
            
        "res://Assets/Bunnies/Skins/Paths/Void01.png":
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
            
        "res://Assets/Bunnies/Paths/Gooey02.png":
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
            
        "res://Assets/Bunnies/Skins/Paths/Void02.png":
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Gooey.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func aplicar_upgrade(caminho: int):
    if caminho == 1:
        
        if skin:
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
        else:
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
        
    elif caminho == 2:

        if skin:
            $Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
        else:
            $Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")
