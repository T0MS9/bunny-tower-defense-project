extends Node2D

var mostrar_range = false
var dmg_Slasher = 3

#@onready encontra os nós assim que o jogo começa
@onready var moedas_label = get_tree().current_scene.find_child("Moedas", true, false)
@onready var moedas_barra = get_tree().current_scene.find_child("PGB_M", true, false)

@onready var SlasherNormal = preload("res://Assets/Bunnies/Slasher.png")
@onready var SlasherUlt = preload("res://Assets/Others/Abilities & Utilities/SlasherUlt.png")

func _process(delta: float) -> void:
	if $Timer.time_left <= 0.3:
		$Slasher.texture = (SlasherUlt)
		
	$ProgressBar.value = $Timer.time_left


#DRAW RANGE E ATAQUE
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

func _on_timer_timeout() -> void:
	var corpos = $Range.get_overlapping_bodies()
	
	for corpo in corpos:
		if corpo.is_in_group("Ghostlings"):
			atacar(corpo)
			# Se for para atacar apenas UM de cada vez, coloca um 'break' aqui
			break
		

func atacar(alvo):
	if alvo.has_method("DMGED"):
		$Slasher/AnimationPlayer.play("LuckyAction")
		alvo.DMGED(dmg_Slasher)
		$Timer.start()
		$Slasher.texture = (SlasherNormal)
