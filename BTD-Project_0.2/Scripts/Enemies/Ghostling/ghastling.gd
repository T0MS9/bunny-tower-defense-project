extends CharacterBody2D

@export var speed_base = 550
@export var speed = 550
@export var vida = 2

const slimed = preload("res://Assets/Enemies/Ghostlings/Ghaztling_Slimed.png")


func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta
	
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 3)
		
		var spawner_no = get_tree().get_first_node_in_group("spawner")
		spawner_no.inimigo_morreu()
		get_parent().queue_free()

func DMGED(quantidade):
	vida -= quantidade
	
	if vida <= 0:
		var moedas = get_tree().current_scene.find_child("Moedas")
		var valor_atual = int(moedas.text)
		moedas.text = str(valor_atual + 1)
		
		speed = 0
		set_physics_process(false) 
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		await $AnimationPlayer.animation_finished
		
		var spawner_no = get_tree().get_first_node_in_group("spawner")
		spawner_no.inimigo_morreu()
		
		get_parent().queue_free()
		
		
		
func gooey_stun(TimeSlimed: float):
	#$AnimationPlayer.play("Animations/ghostling_TakeSlime")
	$Ghaztling.texture = slimed
	speed = speed_base / 3
	
	await get_tree().create_timer(TimeSlimed).timeout
	$Ghaztling.texture = load("res://Assets/Enemies/Ghostlings/Ghaztling.png")
	speed = speed_base
