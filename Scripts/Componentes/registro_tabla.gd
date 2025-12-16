extends HBoxContainer

const CAMPO = preload("res://Scenes/Componentes/campo_tabla.tscn")

signal seleccionado(ind: int)

func inicializa(titulos: Array, is_sostenido=false) -> void:
	for titulo in titulos:
		var campo = CAMPO.instantiate()
		add_child(campo)
		campo.toggle_mode = is_sostenido
		campo.size_flags_stretch_ratio = titulo.size_flags_stretch_ratio
		if is_sostenido:
			campo.pressed.connect(pulsado)

func set_value(ind: int, value: String) -> void:
	get_children()[ind].text = value

func get_value(ind: int) -> String:
	return get_children()[ind].text

func get_registro(ind: int) -> Node:
	return get_children()[ind]

func pulsado() -> void:
	set_presionado(true)
	seleccionado.emit(int(get_value(0)))

func set_presionado(is_press: bool) -> void:
	for btn in get_children():
		btn.button_pressed = is_press

func soy_presionado(ind: int) -> void:
	set_presionado(ind == int(get_value(0)))
