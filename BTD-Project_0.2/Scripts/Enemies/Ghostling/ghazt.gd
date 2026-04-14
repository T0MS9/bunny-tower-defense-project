extends CharacterBody2D

@export var speed = 210
@export var vida = 2
var speed_base = 210 

const slimed = preload("res://Assets/Enemies/Ghostlings/Ghazt_Slimed.png")


func _physics_process(delta):
	var pf = get_parent() as PathFollow2D
	pf.progress += speed * delta

#codigo q perder vidas quando chega ao fim (NGM)
	if $"..".progress_ratio >= 0.99:
		get_tree().call_group("HP", "take_dmg", 2)
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
		
		var spawner_no = get_tree().get_first_node_in_group("spawner")
		spawner_no.inimigo_morreu()
		
		get_parent().queue_free()
		
func gooey_stun(TimeSlimed: float):
	#$AnimationPlayer.play("Animations/ghostling_TakeSlime")
	$Ghazt.texture = slimed
	speed = speed_base / 3
	
	await get_tree().create_timer(TimeSlimed).timeout
	$Ghazt.texture = load("res://Assets/Enemies/Ghostlings/Ghazt.png")
	speed = speed_base 
