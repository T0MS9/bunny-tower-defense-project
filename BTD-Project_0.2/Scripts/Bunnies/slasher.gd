extends Node2D

var mostrar_range = false
var dmg_Slasher = 3

# Usamos @onready para encontrar os nós assim que o jogo começa
@onready var moedas_label = get_tree().current_scene.find_child("Moedas", true, false)
@onready var moedas_barra = get_tree().current_scene.find_child("PGB_M", true, false)

# --- RESTO DO TEU CÓDIGO (DRAW E ATAQUE) ---
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

func atacar(alvo):
	if alvo.has_method("DMGED"):
		$Slasher/AnimationPlayer.play("LuckyAction")
		alvo.DMGED(dmg_Slasher)
