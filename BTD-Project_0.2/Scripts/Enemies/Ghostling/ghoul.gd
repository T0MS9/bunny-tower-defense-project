extends CharacterBody2D

@export var speed = 235
@export var vida = 3
var speed_base = 235

const slimed = preload("res://Assets/Enemies/Ghostlings/Ghoul_Slimed.png")


func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

#codigo q perder vidas quando chega ao fim (NGM)
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 3)
		get_parent().queue_free()

func DMGED(quantidade):
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	
	vida -= quantidade
	$AnimationPlayer.play("Animations/ghostling_TakeDMG")

	moedas.text = str(valor_atual + quantidade)
	
	if vida <= 0:
		var novo_total = int(moedas.text)
		moedas.text = str(novo_total + 1)
		
		speed = 0
		set_physics_process(false) 
		$AnimationPlayer.play("Animations/ghostling_TakeDMG")
		await $AnimationPlayer.animation_finished
		get_node("../../GhostlingSpawner").inimigo_morreu()
		get_parent().queue_free()


func gooey_stun(TimeSlimed: float):
	#$AnimationPlayer.play("Animations/ghostling_TakeSlime")
	$Ghoul.texture = slimed
	speed = speed_base / 3
	
	await get_tree().create_timer(TimeSlimed).timeout
	$Ghoul.texture = load("res://Assets/Enemies/Ghostlings/Ghoul.png")
	speed = speed_base 
