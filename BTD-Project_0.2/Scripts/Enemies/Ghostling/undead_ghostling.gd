extends CharacterBody2D

@export var speed = 210
@export var vida = 10
var speed_base = 210
var stunned = false

const slimed = preload("res://Assets/Enemies/Ghostlings/Undead Ghostling_Slimed.png")

func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 7)
		get_parent().queue_free()

func DMGED(quantidade):
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	if stunned:
		
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		vida -= quantidade
		moedas.text = str(valor_atual + quantidade)
	
		if vida <= 0:
			moedas.text = str(valor_atual + 9)
		
		
			speed = 0 
			set_physics_process(false) 
			$AnimationPlayer.play("Animations/ghostling_TakeDMG")
			await $AnimationPlayer.animation_finished
			get_parent().queue_free()
	else:
		pass

func gooey_stun(TimeSlimed: float):
	$UndeadGhostling.texture = slimed
	stunned = true
	speed = speed_base / 2
	
	await get_tree().create_timer(TimeSlimed).timeout
	stunned = false
	$UndeadGhostling.texture = load("res://Assets/Enemies/Ghostlings/Undead Ghostling.png")
	speed = speed_base 
