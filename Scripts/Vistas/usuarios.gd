extends Panel

const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

var actualizar = false

func _ready() -> void:
	_on_opt_tipo_item_selected(0)
	$PanelDetalles/TxtTelefono.pressed.connect(preguntar.bind("telefono"))
	$PanelDetalles/TxtEmail.pressed.connect(preguntar.bind("email"))
	$PanelDetalles/TxtCentro.pressed.connect(preguntar.bind("centro_id"))
	$PanelDetalles/TxtRol.pressed.connect(preguntar.bind("rol_id"))
	get_parent().get_node("Pregunta").resultado.connect(resultado)
	get_parent().get_node("Modelos").actualizacion.connect(actualizacion)

func actualizacion() -> void:
	actualizar = true

func _process(_delta: float) -> void:
	if actualizar:
		actualizar = false
		var md = get_parent().get_node("Modelos")
		get_parent().set_selector_grupo(md.get_node("Centros").get_nombres(), "opt_centros")
		show_registros()
		seleccionado(int($PanelDetalles/TxtId.text))

func preguntar(tipo: String) -> void:
	if $PanelDetalles/TxtId.text == "0":
		return
	var md = get_parent().get_node("Modelos")
	var qst = get_parent().get_node("Pregunta")
	var dic_pregunta = {
		"data": md.get_node("Usuarios").data,
		"id": int($PanelDetalles/TxtId.text),
		"valor": "",
		"tipo": tipo,
		"quien": self
	}
	var params = [qst.TIPO.OPTION, "", ""]
	match tipo:
		"telefono":
			params[0] = qst.TIPO.LINE
			params[1] = "Digite un teléfono"
		"email":
			params[0] = qst.TIPO.LINE
			params[1] = "Digite un eMail"
		"centro_id":
			params[0] = qst.TIPO.OPTION
			params[1] = "Escoja un centro"
			params[2] = md.get_node("Centros").get_nombres()
		"rol_id":
			params[0] = qst.TIPO.OPTION
			params[1] = "Escoja un rol"
			params[2] = md.ROLES
	var defecto = ""
	match params[0]:
		qst.TIPO.OPTION:
			defecto = 0
		qst.TIPO.QUEST:
			defecto = true
	dic_pregunta["valor"] = md.get_valor(
		dic_pregunta["data"],
		dic_pregunta["id"],
		dic_pregunta["tipo"],
		defecto
	)
	if params[0] == qst.TIPO.LINE:
		params[2] = dic_pregunta["valor"]
	qst.preguntar(params[0], params[1], params[2], dic_pregunta)

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func _on_btn_buscar_pressed() -> void:
	var nombre = $PanelFiltros/LinNombre.text
	var valor = $PanelFiltros/LinTipo.text
	var tipo = $PanelFiltros/OptTipo.get_selected_id()
	tipo = $PanelFiltros/OptTipo.get_item_text(tipo)
	match tipo:
		"Cédula":
			tipo = "cedula"
		"Teléfono":
			tipo = "telefono"
		"eMail":
			tipo = "email"
		"Centro":
			tipo = "centro_id"
	var rol_id = $PanelFiltros/OptRol.get_selected_id()
	var centro_id = $PanelFiltros/OptCentro.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var usuarios = md.get_node("Usuarios").busca_usuarios(nombre, valor, tipo, rol_id, centro_id)
	set_data(usuarios)

func set_data(data: Array) -> void:
	for r in $PanelTabla/Tabla/Registros.get_children():
		r.queue_free()
	for usr in data:
		var r = REGISTRO.instantiate()
		$PanelTabla/Tabla/Registros.add_child(r)
		r.inicializa($PanelTabla/Titulos.get_children(), true)
		r.set_value(0, str(usr["id"]))
		r.seleccionado.connect(seleccionado)
	if data.size() == 1:
		$PanelDetalles/TxtId.text = str(data[0]["id"])
	else:
		$PanelDetalles/TxtId.text = "0"
	actualizacion()

func show_registros():
	var tipo = $PanelFiltros/OptTipo.get_selected_id()
	tipo = $PanelFiltros/OptTipo.get_item_text(tipo)
	$PanelTabla/Titulos/TxtTipo.text = tipo
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var usr = md.get_node("Usuarios").get_data(int(r.get_value(0)))
		r.set_value(1, usr["nombre"])
		match tipo:
			"Cédula":
				r.set_value(2, usr["cedula"])
			"Teléfono":
				r.set_value(2, usr["telefono"])
			"eMail":
				r.set_value(2, usr["email"])
			"Centro":
				r.set_value(2, md.get_node("Centros").get_nombre(usr["centro_id"]))
		var rol = $PanelFiltros/OptRol.get_item_text(usr["rol_id"])
		r.set_value(3, rol)

func seleccionado(id=-1):
	if id == -1:
		$PanelDetalles/TxtNombre.text = "*** Nombre ***"
		$PanelDetalles/TxtCedula.text = "*** Cédula ***"
		$PanelDetalles/TxtTelefono.text = "*** Teléfono ***"
		$PanelDetalles/TxtEmail.text = "*** eMail ***"
		$PanelDetalles/TxtCentro.text = "*** Centro ***"
		$PanelDetalles/TxtRol.text = "*** Rol ***"
		$PanelDetalles/TxtId.text = "0"
	else:
		var md = get_parent().get_node("Modelos")
		var usr = md.get_node("Usuarios").get_data(id)
		$PanelDetalles/TxtNombre.text = usr["nombre"]
		$PanelDetalles/TxtCedula.text = "cc: " + usr["cedula"]
		var tel = "tel: " + usr["telefono"] if usr["telefono"] != "" else "*** Teléfono ***"
		$PanelDetalles/TxtTelefono.text = tel
		var mail = "mail: " + usr["email"] if usr["email"] != "" else "*** eMail ***"
		$PanelDetalles/TxtEmail.text = mail
		$PanelDetalles/TxtCentro.text = md.get_node("Centros").get_nombre(usr["centro_id"])
		$PanelDetalles/TxtRol.text = md.ROLES[usr["rol_id"]]
		$PanelDetalles/TxtId.text = str(id)
		for r in $PanelTabla/Tabla/Registros.get_children():
			r.soy_presionado(id)

func _on_btn_nuevo_pressed() -> void:
	get_parent().set_vista("NuevoUsuario")

func buscar_cedula(cedula: String) -> void:
	$PanelFiltros/LinNombre.text = ""
	$PanelFiltros/LinTipo.text = cedula
	$PanelFiltros/OptCentro.select(0)
	$PanelFiltros/OptTipo.select(0)
	$PanelFiltros/OptRol.select(0)
	_on_btn_buscar_pressed()

func _on_opt_tipo_item_selected(index: int) -> void:
	var tipo = $PanelFiltros/OptTipo.get_item_text(index)
	if tipo == "Centro":
		$PanelFiltros/LinTipo.visible = false
		$PanelFiltros/OptCentro.visible = true
	else:
		$PanelFiltros/LinTipo.visible = true
		$PanelFiltros/OptCentro.visible = false
	$PanelFiltros/LinTipo.placeholder_text = tipo
	$PanelFiltros/LinTipo.text = ""
	$PanelFiltros/OptCentro.select(0)
	show_registros()

# botones para navegar a las otras interfaces

func _on_btn_permisos_pressed() -> void:
	if $PanelDetalles/TxtId.text != "0":
		var id = int($PanelDetalles/TxtId.text)
		get_parent().get_node("Permisos").propagado(id)
		get_parent().set_vista("Permisos")

func _on_btn_credenciales_pressed() -> void:
	if $PanelDetalles/TxtId.text != "0":
		var id = int($PanelDetalles/TxtId.text)
		get_parent().get_node("Credenciales").propagado(id)
		get_parent().set_vista("Credenciales")
