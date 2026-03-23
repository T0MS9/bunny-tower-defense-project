extends Node2D

var pronto_para_atacar = false
var mostrar_range = false
var contagem_ult = 0
var dmg_Slasher = 3

@onready var SlasherNormal = preload("res://Assets/Bunnies/Slasher.png")
@onready var SlasherUlt = preload("res://Assets/Others/Abilities & Utilities/SlasherUlt.png")


func _process(delta: float) -> void:
	$ProgressBar.value = contagem_ult
	$ProgressBar/ProgressBar.value = contagem_ult
	# Se o timer acabou (time_left == 0) e não estamos recarregando
	if $Timer.is_stopped():
		pronto_para_atacar = true

	# VERIFICAÇÃO CONSTANTE: Se estiver pronto, procura alguém
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
		$Slasher/AnimationPlayer.play("LuckyAction")
		contagem_ult += 1
		
		if contagem_ult >= 20:
			$Slasher.texture = SlasherUlt
			alvo.DMGED(dmg_Slasher * 2)
			
			if contagem_ult >= 30:
				$Slasher.texture = SlasherNormal
				alvo.DMGED(dmg_Slasher)
				contagem_ult = 0
				
		else:
			$Slasher.texture = SlasherNormal
			alvo.DMGED(dmg_Slasher)
			
		# RESET: Agora ele tem de recarregar
		pronto_para_atacar = false
		$Timer.start() # Recomeça o cooldown de 2.5s





#DRAW RANGE
func _draw() -> void:
	if mostrar_range:
		var shape = $Range/CollisionRange.shape
		if shape is CircleShape2D:
			var raio_final = shape.radius * $Range/CollisionRange.scale.x
			draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void:
	mostrar_range = true
	queue_redraw()

func _on_insp_mouse_exited() -> void:
	mostrar_range = false
	queue_redraw()
