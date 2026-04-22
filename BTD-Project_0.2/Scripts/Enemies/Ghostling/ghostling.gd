extends CharacterBody2D

@export var speed = 200
@export var vida = 1
var speed_base = 200

func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 0.99:
        get_tree().call_group("HP", "take_dmg", 1)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()
        get_parent().queue_free()

func DMGED(quantidade):
    vida -= quantidade


    if vida <= 0:
        $HitBoxGhostling.disabled = true
        var moedas = get_tree().current_scene.find_child("Moedas")
        var valor_atual = int(moedas.text)
        moedas.text = str(valor_atual + 1)


        speed = 0
        $AnimationPlayer.play("Animations/ghostling_TakeDMG")
        $"../POP".play("default")
        
        await $AnimationPlayer.animation_finished
        $Ghostling.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $"../POP".animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()


func gooey_stun(TimeSlimed: float):

    $"../Goo_Splash".play("Green_Goo")
    speed = speed_base / 3
    $HitBoxGoo.disabled = true

    await get_tree().create_timer(TimeSlimed).timeout
    $"../Goo_Splash".play_backwards("Green_Goo")
    $HitBoxGoo.disabled = false
    
    speed = speed_base
