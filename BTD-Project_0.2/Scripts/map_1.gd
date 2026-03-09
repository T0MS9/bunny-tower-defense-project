extends Node2D




func _process(_delta: float) -> void:
	
	var all_ghoztlings = get_tree().get_nodes_in_group("Ghostlings")
	
	for ghostling in all_ghoztlings:
		# Acedemos ao pai (que deve ser o PathFollow2D)
		var o_pai = ghostling.get_parent()
		# Verificamos se o pai é realmente quem move o inimigo no caminho
		if o_pai is PathFollow2D:
			# Agora sim, lemos o progress_ratio do pai
			if o_pai.progress_ratio >= 0.72 and o_pai.progress_ratio <= 0.805:
				ghostling.modulate.a = 0.1
				
				ghostling.set_deferred("collision_layer", 0)
				ghostling.set_deferred("collision_mask", 0)
			else:
				ghostling.modulate.a = 1.0
				ghostling.set_deferred("collision_layer", 1)
				ghostling.set_deferred("collision_mask", 1)
