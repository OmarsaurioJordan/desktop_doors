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
		show_registros()

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func _on_btn_buscar_pressed() -> void:
	var nombre = $PanelFiltros/LinNombre.text
	var direccion = $PanelFiltros/LinDireccion.text
	var con_zona = $PanelFiltros/OptConZona.get_selected_id()
	var con_salon = $PanelFiltros/OptConSalon.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var data = md.get_node("Sedes").busca_sedes(nombre, direccion, con_zona, con_salon)
	set_data(data)

func set_data(data: Array) -> void:
	for r in $PanelTabla/Tabla/Registros.get_children():
		r.queue_free()
	var qst = get_parent().get_node("Pregunta")
	for dt in data:
		var r = REGISTRO.instantiate()
		$PanelTabla/Tabla/Registros.add_child(r)
		r.inicializa($PanelTabla/Titulos.get_children(), false)
		r.set_value(0, str(dt["id"]))
		r.get_registro(1).pressed.connect(qst.pregunta_line.bind("Sedes",
			"nombre", dt["id"], self, "Escriba el nombre de la sede"))
		r.get_registro(2).pressed.connect(qst.pregunta_line.bind("Sedes",
			"direccion", dt["id"], self, "Escriba la dirección de la sede"))
		
		r.get_registro(5).pressed.connect(qst.pregunta_quest.bind("Sedes", dt["id"], self))
	actualizacion()

func show_registros():
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var dt = md.get_node("Sedes").get_data(int(r.get_value(0)))
		r.set_value(1, dt["nombre"])
		r.set_value(2, dt["direccion"])
		r.set_value(3, str(md.get_node("Sedes").get_num_zonas(dt["id"])))
		r.set_value(4, str(md.get_node("Sedes").get_num_salones(dt["id"])))
		r.set_value(5, md.get_activo(dt["activo"]))

func _on_btn_nuevo_pressed() -> void:
	var qst = get_parent().get_node("Pregunta")
	qst.pregunta_crear("Sedes", self)
