extends Node2D

func _process(_delta: float) -> void:
	# 1. Pegamos a lista de todos os ghoztlings vivos no grupo "ghostlings_group"
	var all_ghoztlings = get_tree().get_nodes_in_group("ghostlings_group")
	
	# 2. Para cada bicho na lista, verificamos a posição
	for ghostling in all_ghoztlings:
		# Verificamos se ele está dentro do túnel
		
		if ghostling.progress_ratio >= 0.72 and ghostling.progress_ratio <= 0.805:
			ghostling.modulate.a = 0.3
			
		else:
			ghostling.modulate.a = 1.0
