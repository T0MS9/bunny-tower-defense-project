extends Node2D

func _process(_delta: float) -> void:
	var all_ghoztlings = get_tree().get_nodes_in_group("ghostlings_group")
	
	for ghostling in all_ghoztlings:
		
		if ghostling.progress_ratio >= 0.72 and ghostling.progress_ratio <= 0.805:
			ghostling.modulate.a = 0.1
			
			for child in ghostling.get_children():
				if child is CharacterBody2D:
					child.set_deferred("collision_layer", 0)
					child.set_deferred("collision_mask", 0)

		else:
			ghostling.modulate.a = 1.0

			for child in ghostling.get_children():
				if child is CharacterBody2D:
					child.set_deferred("collision_layer", 1)
					child.set_deferred("collision_mask", 1)
					
