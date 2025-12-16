extends Panel

const CAMPO_HORARIO = preload("res://Scenes/Componentes/campo_horario.tscn")

func _ready() -> void:
	crea_horario()

func crea_horario() -> void:
	var horas = ["7 am", "1 pm", "6 pm", " 11 pm"]
	for h in horas:
		for i in range(7):
			var campo = CAMPO_HORARIO.instantiate()
			$PanelHorario/Horario.add_child(campo)
			campo.text = h
