extends Node2D

func _on_timer_timeout() -> void:
	var corpos = $Area2D.get_overlapping_bodies()

	for corpo in corpos:
		if corpo.is_in_group("Ghostlings"):
			atacar(corpo)

func atacar(alvo):
	if alvo.has_method("DMGED"):
		alvo.DMGED(1)
