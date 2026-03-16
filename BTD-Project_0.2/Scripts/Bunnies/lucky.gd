extends Node2D

@onready var moedas_node = $HUD/PGB_M
var font = load("res://FontText/Coiny-Regular.ttf")
var font_size = 40
var valor_lucky = 5

func _on_timer_timeout() -> void:
	var moedas = get_tree().current_scene.find_child("Moedas")
	var valor_atual = int(moedas.text)
	moedas.text = str(valor_atual + valor_lucky)
	$Lucky/AnimationPlayer.play("LuckyAction")

func label_money():
	var label_M = Label.new()
	$Panel.add_child(label_M)
	
	# 1. Texto e Estilo
	label_M.text = "+" + str(valor_lucky) + "$"
	label_M.modulate = Color(1.0, 0.902, 0.392, 1.0)
	label_M.add_theme_font_override("font", font)
	label_M.add_theme_font_size_override("font_size", 40)
	
	label_M.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.341))
	label_M.add_theme_constant_override("shadow_offset_x", 3)
	label_M.add_theme_constant_override("shadow_offset_y", 3)
	label_M.add_theme_constant_override("shadow_outline_size", 9)
	
	# 2. Posição Aleatória
	var x_aleatorio = randf_range(0, 200)
	var y_aleatorio = randf_range(0, 150)
	label_M.position = Vector2(x_aleatorio, y_aleatorio)
	
	# 3. Animação (Tween)
	var tween = create_tween()
	tween.tween_property(label_M, "modulate:a", 0.0, 1.0)
	tween.parallel().tween_property(label_M, "position:y", label_M.position.y - 20, 1.0)
	
	tween.finished.connect(label_M.queue_free)
