extends Node2D

@onready var path_ghazling = preload("res://Assets/Ghostlings/ghaztling/ghaztling.tscn")

@onready var path_ghosling = preload("res://Assets/Ghostlings/ghostling/ghostling.tscn")

@onready var path_brute = preload("res://Assets/Ghostlings/brute/brute.tscn")



#teste
var tempPath

func random_ghostling() -> int:
	return randi_range(1, 3)


func _on_timer_timeout():
	#var tempPath
	
	match random_ghostling():
		1:
			tempPath = path_ghazling.instantiate()
			pass
		2:
			tempPath = path_ghosling.instantiate()
			pass
		3:
			tempPath = path_brute.instantiate()
			pass

	$"../Path2D".add_child(tempPath)
