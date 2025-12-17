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
		get_parent().set_selector_grupo(md.get_node("Centros").get_nombres(), "opt_centros")
		get_parent().set_selector_grupo(md.get_node("Zonas").get_nombres(), "opt_zonas")
		get_parent().set_selector_grupo(md.get_node("Centros").get_nombres(), "opt_centros")
		show_registros()

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func _on_btn_buscar_pressed() -> void:
	var nombre = $PanelFiltros/LinNombre.text
	var centro_id = $PanelFiltros/OptCentro.get_selected_id()
	var zona_id = $PanelFiltros/OptZona.get_selected_id()
	var sede_id = $PanelFiltros/OptSede.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var data = md.get_node("Salones").busca_salones(nombre, centro_id, zona_id, sede_id)
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
		r.get_registro(1).pressed.connect(qst.pregunta_line.bind("Salones",
			"nombre", dt["id"], self, "Escriba el nombre del ambiente"))
		r.get_registro(2).pressed.connect(qst.pregunta_option.bind("Salones",
			"zona_id", dt["id"], self, "Seleccione la zona donde está el ambiente",
			md.get_node("Zonas").get_nombres()))
		r.get_registro(3).pressed.connect(qst.pregunta_option.bind("Salones",
			"centro_id", dt["id"], self, "Seleccione el centro al que pertenece",
			md.get_node("Centros").get_nombres()))
		r.get_registro(5).pressed.connect(qst.pregunta_quest.bind("Salones", dt["id"], self))
	actualizacion()

func show_registros():
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var dt = md.get_node("Salones").get_data(int(r.get_value(0)))
		r.set_value(1, dt["nombre"])
		r.set_value(2, md.get_node("Zonas").get_nombre(dt["zona_id"]))
		r.set_value(3, md.get_node("Centros").get_nombre(dt["centro_id"]))
		var sede_id = md.get_node("Zonas").get_data(dt["zona_id"])["sede_id"]
		r.set_value(4, md.get_node("Sedes").get_nombre(sede_id))
		r.set_value(5, md.get_activo(dt["activo"]))

func _on_btn_nuevo_pressed() -> void:
	pass
