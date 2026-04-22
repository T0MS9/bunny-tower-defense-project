extends Node2D

# Inimigos disponíveis para o sistema escolher
@export var tipos_inimigos: Array[PackedScene] 

var rodada_atual = 1
var inimigos_vivos = 0
var fila_spawn = []
var ronda_a_decorrer = false

@onready var timer = $Timer

func iniciar_vaga():
    ronda_a_decorrer = true
    
    # 1. Gerar a fila de inimigos proceduralmente
    gerar_ronda_procedural()
    
    # 2. Ajustar velocidade do Timer (aumenta a cada 10 rondas)
    # Ex: Começa em 1.0s. Na ronda 10 vira 0.9s, na 20 vira 0.8s...
    var reducao_tempo = (int(rodada_atual / 10) * 0.05)
    timer.wait_time = max(0.1, 1.0 - reducao_tempo) 
    
    timer.start()

func gerar_ronda_procedural():
    fila_spawn.clear()
    
    # Cálculo do "Orçamento" da ronda (aumenta com o número da ronda)
    var orcamento = 50 + (rodada_atual * 25) 
    
    # Enquanto houver orçamento, adicionamos inimigos
    while orcamento > 0:
        # Escolhe um inimigo aleatório que o orçamento consiga pagar
        # (Podes filtrar por rodada_atual para não spawnar Brutes na ronda 1)
        var inimigo_escolhido = tipos_inimigos.pick_random()
        fila_spawn.append(inimigo_escolhido)
        
        # Subtrai um valor arbitrário do orçamento (podes criar um dicionário de custos)
        orcamento -= 15 

func _on_timer_timeout():
    if fila_spawn.size() > 0:
        var cena = fila_spawn.pop_front()
        var novo_inimigo = cena.instantiate()
        
        # AUMENTO DE VELOCIDADE DOS INIMIGOS
        # Se os teus inimigos tiverem uma variável 'speed'
        if novo_inimigo.get("speed"):
            var bonus_velocidade = (int(rodada_atual / 10) * 10) # +10 speed a cada 10 rondas
            novo_inimigo.speed += bonus_velocidade
            
        get_node("../Path2D").add_child(novo_inimigo)
        inimigos_vivos += 1
    else:
        timer.stop()

func inimigo_morreu():
    inimigos_vivos -= 1
    if inimigos_vivos <= 0 and fila_spawn.size() == 0:
        finalizar_ronda()

func finalizar_ronda():
    ronda_a_decorrer = false
    # Recompensa base + bónus por ronda
    dar_dinheiro(50 + rodada_atual)
    
    rodada_atual += 1
    atualizar_ui()
