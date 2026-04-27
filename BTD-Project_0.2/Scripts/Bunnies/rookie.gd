extends Node2D

var skin = false

var mostrar_range = false
var pronto_para_atacar = false

var nivel_dano = 0
var nivel_velocidade = 0
var dmg_Rookie = 1
var focus = false


func _process(float) -> void :
    
    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar == true:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
        break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Rookie/AnimationPlayer.play("RookieAttack")
        $RookieHands_Attack.play("default")
        
        var sons_hit = [$Hit, $Hit2, $Hit3]
        var som_sorteado = sons_hit[randi() % sons_hit.size()]
        som_sorteado.play()
        
        alvo.DMGED(dmg_Rookie)
        pronto_para_atacar = false
        $Timer.start()



func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false

func mudar_skin():
    skin = !skin
    
    var path = $Rookie.texture.resource_path
    match path:
        "res://Assets/Bunnies/Animations/RookieAttackIdle.png":
            $Rookie.texture = load("res://Assets/Bunnies/Skins/buny.png")
            
            
        "res://Assets/Bunnies/Skins/buny.png":
            $Rookie.texture = load("res://Assets/Bunnies/Animations/RookieAttackIdle.png")
            
            
        "res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png":
            $Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny01.png")
            
            
        "res://Assets/Bunnies/Skins/Paths/buny01.png":
            $Rookie.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/buny01AttackSpriteSheet.png")
            
            
        "res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png":
            $Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny02.png")
            
            
        "res://Assets/Bunnies/Skins/Paths/buny02.png":
            $Rookie.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/buny02AttackSpriteSheet.png")
            

func _on_button_button_down() -> void:
    # 1. Diz a TODOS os nós no grupo "Bunnies" para correrem a função reset_focus
    get_tree().call_group("Bunnies", "reset_focus")
    
    # 2. Agora liga o foco apenas DESTE coelho
    focus = true
    
    # ... resto do teu código (abrir HUD, etc) ...
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Rookie.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func aplicar_upgrade(caminho: int):
    if caminho == 1:
        #nivel_dano += 1
        #dmg_Rookie += 1 # Só ESTE Rookie ganha +1 de dano
        
        if skin:
            $Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny02.png")
        else:
            $Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
            
        
    elif caminho == 2:
        #nivel_velocidade += 1
        #$Timer.wait_time -= 0.1 # Só ESTE Rookie ataca mais rápido
        
        if skin:
            $Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny01.png")

        else:
            $Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
