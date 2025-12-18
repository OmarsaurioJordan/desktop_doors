extends Panel

enum TIPO {
	OPTION,
	LINE,
	QUEST
}

var pregunta = {
	"data": "", # nombre del modelo de informacion
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

func pregunta_option(modelname: String, tipo: String, id: int,
		quien: Node, titulo: String, parametros: Array) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": modelname,
		"id": id,
		"valor": "",
		"tipo": tipo,
		"quien": quien
	}
	dic_pregunta["valor"] = md.get_valor(
		md.get_node(dic_pregunta["data"]).data,
		dic_pregunta["id"],
		dic_pregunta["tipo"], 0)
	preguntar(TIPO.OPTION, titulo, parametros, dic_pregunta)

func pregunta_line(modelname: String, tipo: String, id: int,
		quien: Node, titulo: String) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": modelname,
		"id": id,
		"valor": "",
		"tipo": tipo,
		"quien": quien
	}
	dic_pregunta["valor"] = md.get_valor(
		md.get_node(dic_pregunta["data"]).data,
		dic_pregunta["id"],
		dic_pregunta["tipo"], "")
	preguntar(TIPO.LINE, titulo, dic_pregunta["valor"], dic_pregunta)

func pregunta_quest(modelname: String, id: int, quien: Node, tal_cosa="") -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": modelname,
		"id": id,
		"valor": true,
		"tipo": "activo",
		"quien": quien
	}
	if tal_cosa == "":
		tal_cosa = md.get_node(modelname).get_nombre(id)
	var titulo = "Desea que " + tal_cosa + " sea:"
	dic_pregunta["valor"] = not md.get_valor(
		md.get_node(dic_pregunta["data"]).data,
		dic_pregunta["id"],
		dic_pregunta["tipo"], true)
	var est = "ACTIVADO" if dic_pregunta["valor"] else "DESACTIVADO"
	preguntar(TIPO.QUEST, titulo, est, dic_pregunta)

func pregunta_permisos(usuario_id: int, valor_id: int, tipo: String, quien: Node) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": "Permisos",
		"id": usuario_id,
		"valor": valor_id,
		"tipo": tipo,
		"quien": quien
	}
	var est = "REVOCAR" if md.get_node("Permisos").get_permiso(
		usuario_id, tipo, valor_id) else "PERMITIR"
	preguntar(TIPO.QUEST, "¿Desea cambiar los permisos?", est, dic_pregunta)

func pregunta_navegar(titulo: String, modelname: String, valor, tipo: String) -> void:
	var md = get_parent().get_node("Modelos")
	var dic_pregunta = {
		"data": modelname,
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
	elif pregunta["data"] == "Permisos":
		md.get_node(pregunta["data"]).permiso_switch(pregunta["id"],
			pregunta["tipo"], pregunta["valor"])
		resultado.emit(pregunta["quien"])
		visible = false
		return
	elif pregunta["id"] == -100:
		var preg_data = md.get_node(pregunta["data"]).data
		var data = md.busca_data(preg_data, pregunta["valor"], pregunta["tipo"])
		pregunta["quien"].set_data(data)
		get_parent().set_vista(pregunta["quien"].name)
		visible = false
		return
	var preg_data = md.get_node(pregunta["data"]).data
	md.set_valor(preg_data, pregunta["id"], pregunta["valor"], pregunta["tipo"])
	resultado.emit(pregunta["quien"])
	visible = false
