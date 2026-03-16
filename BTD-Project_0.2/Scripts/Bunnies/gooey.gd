extends Node2D

# --- VARIÁVEIS DE CONFIGURAÇÃO ---
var mostrar_range = false
var pronto_para_atacar = false
var tempo_paralisia = 2.0 # Quanto tempo o fantasma fica parado

func _process(delta: float) -> void:
	# Verifica se o Timer acabou para poder atacar de novo
	if $Timer.is_stopped():
		pronto_para_atacar = true

	if pronto_para_atacar:
		verificar_e_atacar()

func verificar_e_atacar():
	# Pega todos os corpos dentro da Area2D "Range"
	var corpos = $Range.get_overlapping_bodies()
	
	for corpo in corpos:
		if corpo.is_in_group("Ghostlings"):
			atacar(corpo)
			# O Gooey normalmente ataca um de cada vez, 
			# por isso paramos no primeiro que encontrar (break).
			break 

func atacar(alvo):
	# Verificamos se o fantasma tem a função de stun que criámos
	if alvo.has_method("gooey_stun"):
		# Toca a animação de ataque (Gosma)
		$Gooey/AnimationPlayer.play("Gooey_Attack")
		
		# CHAMA O STUN: Passamos o tempo que queremos que ele pare
		alvo.gooey_stun(tempo_paralisia)
		
		# Reset do cooldown
		pronto_para_atacar = false
		$Timer.start()

# --- SISTEMA DE DESENHO DO RANGE (IGUAL AO TEU) ---
func _draw() -> void:
	if mostrar_range:
		var shape = $Range/CollisionRange.shape
		if shape is CircleShape2D:
			var raio_final = shape.radius * $Range/CollisionRange.scale.x
			# Desenha um círculo semi-transparente (Verde para o Gooey?)
			draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void:
	mostrar_range = true
	queue_redraw()

func _on_insp_mouse_exited() -> void:
	mostrar_range = false
	queue_redraw()
