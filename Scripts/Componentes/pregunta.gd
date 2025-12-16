extends Panel

var pregunta = {
	"data": null, # referencia a array del modelo de informacion
	"id": -1, # indice del registro a afectar
	"valor": null, # valor a ser reemplazado
	"tipo": "", # atributo del campo a modificar
	"quien": null # el nodo que hizo la llamada
}

signal resultado(quien: Node)

func _ready() -> void:
	visible = false

func preguntar(tipo: int, titulo: String, parametros, dic_pregunta) -> void:
	visible = true
	$Emergente/TxtTitulo.text = titulo
	pregunta["data"] = dic_pregunta["data"]
	pregunta["id"] = dic_pregunta["id"]
	pregunta["valor"] = dic_pregunta["valor"]
	pregunta["tipo"] = dic_pregunta["tipo"]
	pregunta["quien"] = dic_pregunta["quien"]
	match tipo:
		0: # option
			$Emergente/Option.visible = true
			$Emergente/LinLinea.visible = false
			$Emergente/TxtSuceso.visible = false
			$Emergente/Option/OptOption.clear()
			for p in parametros:
				$Emergente/Option/OptOption.add_item(p)
			$Emergente/Option/OptOption.select(0)
		1: # line
			$Emergente/Option.visible = false
			$Emergente/LinLinea.visible = true
			$Emergente/TxtSuceso.visible = false
			$Emergente/LinLinea.placeholder_text = parametros
		2: # pregunta
			$Emergente/Option.visible = false
			$Emergente/LinLinea.visible = false
			$Emergente/TxtSuceso.visible = true
			$Emergente/TxtSuceso.text = parametros

func _on_btn_cancelar_pressed() -> void:
	visible = false

func _on_btn_aceptar_pressed() -> void:
	if $Emergente/Option.visible:
		pregunta["valor"] = $Emergente/Option.get_selected_id()
	elif $Emergente/LinLinea.visible:
		pregunta["valor"] = $Emergente/LinLinea.text
	var md = get_parent().get_node("Modelos")
	md.set_valor(pregunta["data"], pregunta["id"], pregunta["valor"], pregunta["tipo"])
	resultado.emit(pregunta["quien"])
	visible = false
