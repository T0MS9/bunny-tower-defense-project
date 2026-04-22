extends CharacterBody2D

@export var speed = 210
@export var vida = 2
var speed_base = 210

var goo_stun = false

func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta


    if $"..".progress_ratio >= 0.99:
        get_tree().call_group("HP", "take_dmg", 2)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()
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
        $AnimationPlayer.play("Animations/ghostling_TakeDMG")
        $"../POP".play("default")
        
        await $AnimationPlayer.animation_finished
        $Ghazt.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $"../POP".animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    $"../Goo_Splash".visible = true
    $"../Goo_Splash".play(cor_ataque)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $"../Goo_Splash".play_backwards(cor_ataque)
        speed = speed_base
        goo_stun = false
