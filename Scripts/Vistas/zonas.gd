extends Panel

const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

var actualizar = false

func _ready() -> void:
	get_parent().get_node("Pregunta").resultado.connect(resultado)
	get_parent().get_node("Modelos").actualizacion.connect(actualizacion)

func actualizacion() -> void:
	actualizar = true

func _process(_delta: float) -> void:
	if actualizar:
		actualizar = false
		var md = get_parent().get_node("Modelos")
		get_parent().set_selector_grupo(md.get_node("Sedes").get_nombres(), "opt_sedes")
		show_registros()

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func _on_btn_buscar_pressed() -> void:
	var nombre = $PanelFiltros/LinNombre.text
	var sede_id = $PanelFiltros/OptSede.get_selected_id()
	var con_grupo = $PanelFiltros/OptConGrupo.get_selected_id()
	var con_salon = $PanelFiltros/OptConSalon.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var data = md.get_node("Zonas").busca_zonas(nombre, sede_id, con_grupo, con_salon)
	set_data(data)

func set_data(data: Array) -> void:
	for r in $PanelTabla/Tabla/Registros.get_children():
		r.queue_free()
	var qst = get_parent().get_node("Pregunta")
	var md = get_parent().get_node("Modelos")
	for dt in data:
		var r = REGISTRO.instantiate()
		$PanelTabla/Tabla/Registros.add_child(r)
		r.inicializa($PanelTabla/Titulos.get_children(), false)
		r.set_value(0, str(dt["id"]))
		r.get_registro(1).pressed.connect(qst.pregunta_line.bind("Zonas",
			"nombre", dt["id"], self, "Escriba el nombre de la zona"))
		r.get_registro(2).pressed.connect(qst.pregunta_option.bind("Zonas",
			"sede_id", dt["id"], self, "Seleccione la sede donde está la zona",
			md.get_node("Sedes").get_nombres()))
		
		r.get_registro(5).pressed.connect(qst.pregunta_quest.bind("Zonas", dt["id"], self))
	actualizacion()

func show_registros():
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var dt = md.get_node("Zonas").get_data(int(r.get_value(0)))
		r.set_value(1, dt["nombre"])
		r.set_value(2, md.get_node("Sedes").get_nombre(dt["sede_id"]))
		r.set_value(3, str(md.get_node("Zonas").get_num_grupos(dt["id"])))
		r.set_value(4, str(md.get_node("Zonas").get_num_salones(dt["id"])))
		r.set_value(5, md.get_activo(dt["activo"]))

func _on_btn_nuevo_pressed() -> void:
	var qst = get_parent().get_node("Pregunta")
	qst.pregunta_crear("Zonas", self)
