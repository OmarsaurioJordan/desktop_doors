extends Panel

const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

var actualizar = false
var my_propagado = 0

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

func propagado(id=0):
	my_propagado = id
	if id != 0:
		var md = get_parent().get_node("Modelos")
		var usr = md.get_node("Usuarios").get_data(id)
		$Volver/TxtNombre.text = usr["nombre"]
		$Volver/TxtCedula.text = "cc: " + usr["cedula"]
		$PanelFiltros/LinTipo.text = ""
		$PanelFiltros/OptTipo.select(4)
		$PanelFiltros/OptSede.select(0)
		_on_btn_buscar_pressed()

func _on_btn_buscar_pressed() -> void:
	var nombre = $PanelFiltros/LinTipo.text
	var tipo = $PanelFiltros/OptTipo.get_selected_id()
	var sede_id = $PanelFiltros/OptSede.get_selected_id()
	var md = get_parent().get_node("Modelos")
	var data: Array
	if tipo == 0 or tipo == 1:
		data = md.get_node("Grupos").busca_grupos(nombre)
		set_data(data, $PanelGrupo, "grupo_id")
	if tipo == 0 or tipo == 2:
		data = md.get_node("Zonas").busca_zonas(nombre, sede_id)
		set_data(data, $PanelZona, "zona_id")
	if tipo == 0 or tipo == 3:
		data = md.get_node("Salones").busca_salones(nombre, 0, 0, sede_id)
		set_data(data, $PanelSalon, "salon_id")
	if tipo == 4:
		data = md.get_node("Permisos").busca_grupos(my_propagado)
		set_data(data, $PanelGrupo, "grupo_id")
		data = md.get_node("Permisos").busca_zonas(my_propagado)
		set_data(data, $PanelZona, "zona_id")
		data = md.get_node("Permisos").busca_salones(my_propagado)
		set_data(data, $PanelSalon, "salon_id")

func set_data(data: Array, nodo: Node, tipo: String) -> void:
	for r in nodo.get_node("Tabla/Registros").get_children():
		r.queue_free()
	var qst = get_parent().get_node("Pregunta")
	for dt in data:
		var r = REGISTRO.instantiate()
		nodo.get_node("Tabla/Registros").add_child(r)
		r.inicializa(nodo.get_node("Titulos").get_children(), false)
		r.set_value(0, str(dt["id"]))
		r.get_registro(2).pressed.connect(qst.pregunta_permisos.bind(
			my_propagado, dt["id"], tipo, self))
	actualizacion()

func show_registros():
	var md = get_parent().get_node("Modelos")
	show_registrox($PanelGrupo, md.get_node("Permisos").busca_grupos(my_propagado), "Grupos")
	show_registrox($PanelZona, md.get_node("Permisos").busca_zonas(my_propagado), "Zonas")
	show_registrox($PanelSalon, md.get_node("Permisos").busca_salones(my_propagado), "Salones")

func show_registrox(nodo: Node, my_data: Array, tablename: String):
	var md = get_parent().get_node("Modelos")
	for r in nodo.get_node("Tabla/Registros").get_children():
		var id = int(r.get_value(0))
		var dt = md.get_node(tablename).get_data(id)
		r.set_value(1, dt["nombre"])
		r.set_value(2, md.get_activo(not md.get_data(my_data, id).is_empty()))

func _on_btn_volver_pressed() -> void:
	get_parent().set_vista("Usuarios")
