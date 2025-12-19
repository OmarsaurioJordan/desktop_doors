extends Panel

const CAMPO_HORARIO = preload("res://Scenes/Componentes/campo_horario.tscn")
const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

var actualizar = false
var my_seleccionado = -1

func _ready() -> void:
	get_parent().get_node("Pregunta").resultado.connect(resultado)
	get_parent().get_node("Modelos").actualizacion.connect(actualizacion)
	crea_horario()
	$PanelUsuario/Datos1/TxtNombre.pressed.connect(set_nombre)
	$PanelUsuario/Datos1/TxtSalon.pressed.connect(set_salon)
	$PanelUsuario/Datos1/TxtFechaIni.pressed.connect(set_fecha.bind("inicio"))
	$PanelUsuario/Datos2/TxtFechaFin.pressed.connect(set_fecha.bind("final"))

func crea_horario() -> void:
	var horas = ["7 am", "1 pm", "6 pm", " 11 pm"]
	for h in horas:
		for i in range(7):
			var campo = CAMPO_HORARIO.instantiate()
			$PanelHorario/Horario.add_child(campo)
			campo.text = h
			campo.pressed.connect(cambia_horario)

func actualizacion() -> void:
	actualizar = true

func _process(_delta: float) -> void:
	if actualizar:
		actualizar = false
		var md = get_parent().get_node("Modelos")
		get_parent().set_selector_grupo(md.get_node("Usuarios").get_nombres(), "opt_usuarios")
		get_parent().set_selector_grupo(md.get_node("Salones").get_nombres(), "opt_salones")
		get_parent().set_selector_grupo(md.get_node("Centros").get_nombres(), "opt_centros")
		get_parent().set_selector_grupo(md.get_node("Sedes").get_nombres(), "opt_sedes")
		show_registros()
		seleccionado(my_seleccionado)

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func _on_btn_buscar_pressed() -> void:
	var usuario_id = $PanelFiltros/OptUsuario.get_selected_id()
	var salon_id = $PanelFiltros/OptSalon.get_selected_id()
	var centro_id = $PanelFiltros/OptCentro.get_selected_id()
	var sede_id = $PanelFiltros/OptSede.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var data = md.get_node("Horarios").busca_horarios(usuario_id, salon_id, centro_id, sede_id)
	set_data(data)

func set_data(data: Array) -> void:
	for r in $PanelTabla/Tabla/Registros.get_children():
		r.queue_free()
	var qst = get_parent().get_node("Pregunta")
	for dt in data:
		var r = REGISTRO.instantiate()
		$PanelTabla/Tabla/Registros.add_child(r)
		r.inicializa($PanelTabla/Titulos.get_children(), true)
		r.set_value(0, str(dt["id"]))
		r.seleccionado.connect(seleccionado)
	actualizacion()

func seleccionado(id=-1):
	my_seleccionado = id
	if id == -1:
		$PanelUsuario/Datos1/TxtNombre.text = "*** Nombre ***"
		$PanelUsuario/Datos1/TxtSalon.text = "*** Ambiente ***"
		$PanelUsuario/Datos1/TxtFechaIni.text = "*** Inicial ***"
		$PanelUsuario/Datos2/TxtFechaFin.text = "*** Final ***"
		$PanelUsuario/Datos2/TxtCedula.text = "*** Cédula ***"
		$PanelUsuario/Datos2/TxtZona.text = "*** Zona ***"
		$PanelUsuario/Datos3/TxtCentro.text = "*** Centro ***"
		$PanelUsuario/Datos3/TxtSede.text = "*** Sede ***"
		$PanelUsuario/Datos3/TxtVigente.text = "*** Vigente ***"
	else:
		var md = get_parent().get_node("Modelos")
		var hor = md.get_node("Horarios").get_data(id)
		$PanelUsuario/Datos1/TxtNombre.text = md.get_node("Usuarios").get_nombre(hor["usuario_id"])
		$PanelUsuario/Datos1/TxtSalon.text = md.get_node("Salones").get_nombre(hor["salon_id"])
		$PanelUsuario/Datos1/TxtFechaIni.text = "I: " +\
			Time.get_date_string_from_unix_time(hor["inicio"])
		$PanelUsuario/Datos2/TxtFechaFin.text = "F: " +\
			Time.get_date_string_from_unix_time(hor["final"])
		var udt = md.get_node("Usuarios").get_all()
		$PanelUsuario/Datos2/TxtCedula.text = "cc: " +\
			md.get_valor(udt, hor["usuario_id"], "cedula", "")
		var zona_id = md.get_node("Salones").get_data(hor["salon_id"])["zona_id"]
		$PanelUsuario/Datos2/TxtZona.text = md.get_node("Zonas").get_nombre(zona_id)
		var centro_id = md.get_node("Usuarios").get_data(hor["usuario_id"])["centro_id"]
		$PanelUsuario/Datos3/TxtCentro.text = "centro: " +\
			md.get_node("Centros").get_nombre(centro_id)
		var sede_id = md.get_node("Zonas").get_data(zona_id)["sede_id"]
		$PanelUsuario/Datos3/TxtSede.text = md.get_node("Sedes").get_nombre(sede_id)
		var act = Time.get_unix_time_from_system()
		var act_str = "ACTIVO" if act > hor["inicio"] and act < hor["final"] else "INACTIVO"
		$PanelUsuario/Datos3/TxtVigente.text = act_str
		set_horario(hor["horario"])
		for r in $PanelTabla/Tabla/Registros.get_children():
			r.soy_presionado(id)

func set_horario(horario: String) -> void:
	var i = -7
	for hor in $PanelHorario/Horario.get_children():
		if i >= 0:
			hor.button_pressed = horario.substr(i, 1) == "1"
		i += 1

func get_horario() -> String:
	var res = ""
	var i = -7
	for hor in $PanelHorario/Horario.get_children():
		if i >= 0:
			res += "1" if hor.button_pressed else "0"
		i += 1
	return res

func show_registros():
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var dt = md.get_node("Horarios").get_data(int(r.get_value(0)))
		match $PanelTabla/Titulos/OptFiltro.get_selected_id():
			0:
				r.set_value(1, md.get_node("Usuarios").get_nombre(dt["usuario_id"]))
			1:
				r.set_value(1, md.get_node("Salones").get_nombre(dt["salon_id"]))
			2:
				r.set_value(1, Time.get_date_string_from_unix_time(dt["inicio"]))
			3:
				r.set_value(1, Time.get_date_string_from_unix_time(dt["final"]))

func _on_btn_nuevo_pressed() -> void:
	var qst = get_parent().get_node("Pregunta")
	qst.pregunta_crear("Horarios", self)

func set_nombre() -> void:
	if my_seleccionado == -1:
		return
	var qst = get_parent().get_node("Pregunta")
	var md = get_parent().get_node("Modelos")
	var parametros = md.get_node("Usuarios").get_nombres()
	qst.pregunta_option("Horarios", "usuario_id", my_seleccionado,
		self, "Elija a un usuario", parametros)

func set_salon() -> void:
	if my_seleccionado == -1:
		return
	var qst = get_parent().get_node("Pregunta")
	var md = get_parent().get_node("Modelos")
	var parametros = md.get_node("Salones").get_nombres()
	qst.pregunta_option("Horarios", "salon_id", my_seleccionado,
		self, "Elija a un ambiente", parametros)

func set_fecha(tipo: String) -> void:
	if my_seleccionado == -1:
		return
	var qst = get_parent().get_node("Pregunta")
	qst.pregunta_fecha("Horarios", tipo, my_seleccionado, self)

func cambia_horario() -> void:
	if my_seleccionado == -1:
		return
	var horario = get_horario()
	var md = get_parent().get_node("Modelos")
	md.get_node("Horarios").set_valor(my_seleccionado, horario, "horario")

func _on_opt_filtro_item_selected(index: int) -> void:
	actualizacion()
