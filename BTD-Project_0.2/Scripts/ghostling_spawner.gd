extends Node2D

@onready var path_ghazling = preload("res://Scenes/Enemies/Ghostling/ghaztling.tscn")
@onready var path_ghosling = preload("res://Scenes/Enemies/Ghostling/ghostling.tscn")
@onready var path_brute = preload("res://Scenes/Enemies/Ghostling/brute.tscn")

var tempPath

func random_ghostling() -> int:
	return randi_range(1, 3)

func _on_timer_timeout():
	match random_ghostling():
		1:
			tempPath = path_ghazling.instantiate()
		2:
			tempPath = path_ghosling.instantiate()
		3:
			tempPath = path_brute.instantiate()


	tempPath.add_to_group("ghostlings_group")
	$"../Path2D".add_child(tempPath)
