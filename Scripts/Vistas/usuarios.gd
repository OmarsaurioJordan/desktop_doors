extends Panel

const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

func _ready() -> void:
	_on_opt_tipo_item_selected(0)
	$PanelDetalles/TxtTelefono.pressed.connect(preguntar.bind("telefono"))
	get_parent().get_node("Pregunta").resultado.connect(resultado)

func preguntar(tipo: String) -> void:
	if $PanelDetalles/TxtId.text == "0":
		return
	var dic_pregunta = {
		"data": get_parent().get_node("Modelos/Usuarios").data,
		"id": int($PanelDetalles/TxtId.text),
		"valor": "",
		"tipo": tipo,
		"quien": self
	}
	var md = get_parent().get_node("Modelos")
	var params = [0, "", ""]
	match tipo:
		"telefono":
			params[0] = 1
			params[1] = "Digite un teléfono"
			params[2] = $PanelDetalles/TxtTelefono.text
		"email":
			params[0] = 1
			params[1] = "Digite un eMail"
			params[2] = $PanelDetalles/TxtEmail.text
		"centro_id":
			params[0] = 0
			params[1] = "Escoja un centro"
			params[2] = md.get_node("Centros").get_nombres()
		"rol_id":
			params[0] = 0
			params[1] = "Escoja un rol"
			params[2] = md.ROLES
	get_parent().get_node("Pregunta").preguntar(params[0],
		params[1], params[2], dic_pregunta)

func resultado(quien: Node) -> void:
	if quien == self:
		show_registros()
		seleccionado(int($PanelDetalles/TxtId.text))

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
	var rol_id = $PanelFiltros/OptRol.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var usuarios = md.get_node("Usuarios").busca_usuarios(nombre, valor, tipo, rol_id)
	for r in $PanelTabla/Tabla/Registros.get_children():
		r.queue_free()
	for usr in usuarios:
		var r = REGISTRO.instantiate()
		$PanelTabla/Tabla/Registros.add_child(r)
		r.inicializa($PanelTabla/Titulos.get_children(), true)
		r.set_value(0, str(usr["id"]))
		r.seleccionado.connect(seleccionado)
	show_registros()
	if usuarios.size() == 1:
		seleccionado(usuarios[0]["id"])
	else:
		seleccionado()

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
	$PanelFiltros/OptTipo.select(0)
	$PanelFiltros/OptRol.select(0)
	_on_btn_buscar_pressed()

func _on_opt_tipo_item_selected(index: int) -> void:
	var tipo = $PanelFiltros/OptTipo.get_item_text(index)
	$PanelFiltros/LinTipo.placeholder_text = tipo
	$PanelFiltros/LinTipo.text = ""
	show_registros()
