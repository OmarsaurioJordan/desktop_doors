extends Panel

enum TIPO {
	OPTION,
	LINE,
	QUEST
}

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
		TIPO.OPTION:
			$Emergente/Option.visible = true
			$Emergente/LinLinea.visible = false
			$Emergente/TxtSuceso.visible = false
			get_parent().set_selector_grupo(parametros, "opt_emergente", pregunta["valor"])
		TIPO.LINE:
			$Emergente/Option.visible = false
			$Emergente/LinLinea.visible = true
			$Emergente/TxtSuceso.visible = false
			$Emergente/LinLinea.placeholder_text = parametros
			$Emergente/LinLinea.text = pregunta["valor"]
		TIPO.QUEST:
			$Emergente/Option.visible = false
			$Emergente/LinLinea.visible = false
			$Emergente/TxtSuceso.visible = true
			$Emergente/TxtSuceso.text = parametros

func pregunta_line(modelname: String, tipo: String, id: int, quien: Node, titulo: String) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": md.get_node(modelname).data,
		"id": id,
		"valor": "",
		"tipo": tipo,
		"quien": quien
	}
	dic_pregunta["valor"] = md.get_valor(
		dic_pregunta["data"],
		dic_pregunta["id"],
		dic_pregunta["tipo"], "")
	preguntar(TIPO.LINE, titulo, dic_pregunta["valor"], dic_pregunta)

func pregunta_quest(modelname: String, id: int, quien: Node) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": md.get_node(modelname).data,
		"id": id,
		"valor": true,
		"tipo": "activo",
		"quien": quien
	}
	var titulo = "Desea que " + md.get_node(modelname).get_nombre(id) + " sea:"
	dic_pregunta["valor"] = not md.get_valor(
		dic_pregunta["data"],
		dic_pregunta["id"],
		dic_pregunta["tipo"], true)
	var est = "ACTIVADO" if dic_pregunta["valor"] else "DESACTIVADO"
	preguntar(TIPO.QUEST, titulo, est, dic_pregunta)

func pregunta_navegar(titulo: String, modelname: String, valor, tipo: String) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": md.get_node(modelname).data,
		"id": -100,
		"valor": valor,
		"tipo": tipo,
		"quien": get_parent().get_node(modelname)
	}
	preguntar(TIPO.QUEST, titulo, "pulse ACEPTAR para navegar", dic_pregunta)

func _on_btn_cancelar_pressed() -> void:
	visible = false

func _on_btn_aceptar_pressed() -> void:
	var md = get_parent().get_node("Modelos")
	if $Emergente/Option.visible:
		pregunta["valor"] = $Emergente/Option/OptOption.get_selected_id()
	elif $Emergente/LinLinea.visible:
		pregunta["valor"] = $Emergente/LinLinea.text
	elif pregunta["id"] == -100:
		var data = md.busca_data(pregunta["data"], pregunta["valor"], pregunta["tipo"])
		pregunta["quien"].set_data(data)
		get_parent().set_vista(pregunta["quien"].name)
		visible = false
		return
	md.set_valor(pregunta["data"], pregunta["id"], pregunta["valor"], pregunta["tipo"])
	resultado.emit(pregunta["quien"])
	visible = false
