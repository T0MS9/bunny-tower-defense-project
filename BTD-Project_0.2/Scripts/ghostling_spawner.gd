extends Node2D

@onready var EasyGhostlings = [
	preload("res://Scenes/Enemies/Ghostling/ghaztling.tscn"),
	preload("res://Scenes/Enemies/Ghostling/ghostling.tscn"),
	preload("res://Scenes/Enemies/Ghostling/ghazt.tscn"),
	preload("res://Scenes/Enemies/Ghostling/ghoul.tscn"),
]

@onready var HardGhostlings = [
	preload("res://Scenes/Enemies/Ghostling/brute.tscn"),
]

@onready var UndeadGhostlings = [
	preload("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn"),
]

func _on_timer_timeout():
	var All_Ghostlings = EasyGhostlings + HardGhostlings
	
	var Ghostling = All_Ghostlings.pick_random()
	var tempPath = Ghostling.instantiate()
	
	tempPath.add_to_group("Ghostlings")
	$"../Path2D".add_child(tempPath)
