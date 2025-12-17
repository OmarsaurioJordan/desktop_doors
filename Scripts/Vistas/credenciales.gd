extends Panel

const REGISTRO = preload("res://Scenes/Componentes/registro_tabla.tscn")

var actualizar = false
var my_seleccionado = 0
var my_propagado = 0

func _ready() -> void:
	$Adquisicion.visible = false
	get_parent().get_node("Pregunta").resultado.connect(resultado)
	get_parent().get_node("Modelos").actualizacion.connect(actualizacion)

func actualizacion() -> void:
	actualizar = true

func _process(_delta: float) -> void:
	if actualizar:
		actualizar = false
		show_registros()
		seleccionado(my_seleccionado)

func resultado(quien: Node) -> void:
	if quien == self:
		actualizacion()

func propagado(id=0):
	my_propagado = id
	if id != 0:
		var md = get_parent().get_node("Modelos")
		var usr = md.get_node("Usuarios").get_data(id)
		$Volver/TxtNombre.text = usr["nombre"]
		$Volver/TxtCedula.text = usr["cedula"]
		var qst = get_parent().get_node("Pregunta")
		var data = md.get_node("Credenciales").buscar_usuario(id)
		for r in $PanelTabla/Tabla/Registros.get_children():
			r.queue_free()
		for dt in data:
			var r = REGISTRO.instantiate()
			$PanelTabla/Tabla/Registros.add_child(r)
			r.inicializa($PanelTabla/Titulos.get_children(), true)
			r.set_value(0, str(dt["id"]))
			r.seleccionado.connect(seleccionado)
			# Tarea agregar cambio activo
		if data.size() == 0:
			my_seleccionado = 0
		else:
			my_seleccionado = 1
		actualizacion()

func seleccionado(id=0):
	my_seleccionado = id
	$Adquisicion.visible = id != 0
	if id != 0:
		var md = get_parent().get_node("Modelos")
		var cred = md.get_node("Credenciales").get_data(id)
		match cred["tipo_id"]:
			0: # huellero
				$Adquisicion/Huellero.visible = true
				$Adquisicion/Password.visible = false
				$Adquisicion/Otro.visible = false
			1: # facial
				$Adquisicion/Huellero.visible = false
				$Adquisicion/Password.visible = false
				$Adquisicion/Otro.visible = true
			2: # tarjeta
				$Adquisicion/Huellero.visible = false
				$Adquisicion/Password.visible = false
				$Adquisicion/Otro.visible = true
			3: # password
				$Adquisicion/Huellero.visible = false
				$Adquisicion/Password.visible = true
				$Adquisicion/Otro.visible = false
				$Adquisicion/Password/LinPassword1.text = ""
				$Adquisicion/Password/LinPassword2.text = ""
		$Adquisicion/TxtMessage.text = ""
		for r in $PanelTabla/Tabla/Registros.get_children():
			r.soy_presionado(id)

func show_registros():
	var md = get_parent().get_node("Modelos")
	for r in $PanelTabla/Tabla/Registros.get_children():
		var dt = md.get_node("Credenciales").get_data(int(r.get_value(0)))
		r.set_value(1, $NuevoCredencial/TipoCredencial/OptTipoCredencial.get_item_text(
			dt["tipo_id"]))
		r.set_value(2, md.get_activo(dt["activo"]))
		r.set_value(3, "Falta" if dt["datos"] == "" else "Ok")
		r.set_value(4, Time.get_date_string_from_unix_time(dt["fecha"]))

func _on_btn_volver_pressed() -> void:
	get_parent().set_vista("Usuarios")

func _on_btn_adquirir_pressed() -> void:
	if $Adquisicion/Huellero.visible:
		var port = $Adquisicion/Huellero/PuertoHuellero/OptPuertoHuellero.get_selected_id()
		var md = get_parent().get_node("Modelos")
		if md.get_node("Credenciales").get_data(my_seleccionado)["datos"] != "":
			$Adquisicion/TxtMessage.text = "Ya se ha tomado una biometría"
		elif port == 1:
			if randf() < 0.5:
				set_credencial(md.clave_azar(64))
			else:
				$Adquisicion/TxtMessage.text = "Fallo de lectura, reubique el dedo"
		else:
			$Adquisicion/TxtMessage.text = "No se pudo encontrar el dispositivo huellero"
	elif $Adquisicion/Otro.visible:
		$Adquisicion/TxtMessage.text = "No está disponible"
	else:
		var p1 = $Adquisicion/Password/LinPassword1.text
		var p2 = $Adquisicion/Password/LinPassword2.text
		if p1 == "" or p2 == "":
			$Adquisicion/TxtMessage.text = "Digite las constraseñas"
		elif p1 != p2:
			$Adquisicion/TxtMessage.text = "Las contraseñas deben ser iguales"
		else:
			set_credencial(p1)
		$Adquisicion/Password/LinPassword1.text = ""
		$Adquisicion/Password/LinPassword2.text = ""

func set_credencial(valor: String):
	var md = get_parent().get_node("Modelos")
	md.get_node("Credenciales").set_valor(my_seleccionado, valor, "datos")
	var date = Time.get_unix_time_from_system()
	md.get_node("Credenciales").set_valor(my_seleccionado, date, "fecha")
	$TimerOk.start()

func _on_btn_testear_pressed() -> void:
	var md = get_parent().get_node("Modelos")
	if md.get_node("Credenciales").get_data(my_seleccionado)["datos"] == "":
		$Adquisicion/TxtMessage.text = "NO hay un dato en memoria para comparar"
	elif $Adquisicion/Huellero.visible:
		var port = $Adquisicion/Huellero/PuertoHuellero/OptPuertoHuellero.get_selected_id()
		if port == 1:
			if randf() < 0.5:
				$Adquisicion/TxtMessage.text = "La huella leída es correcta"
			else:
				$Adquisicion/TxtMessage.text = "La huella leída NO coincide"
		else:
			$Adquisicion/TxtMessage.text = "No se pudo encontrar el dispositivo huellero"
	elif $Adquisicion/Otro.visible:
		$Adquisicion/TxtMessage.text = "No está disponible"
	else:
		var p = $Adquisicion/Password/LinPassword1.text
		if p == md.get_node("Credenciales").get_data(my_seleccionado)["datos"]:
			$Adquisicion/TxtMessage.text = "La contraseña es correcta"
		else:
			$Adquisicion/TxtMessage.text = "La contraseña NO coincide"
		$Adquisicion/Password/LinPassword1.text = ""
		$Adquisicion/Password/LinPassword2.text = ""

func _on_btn_crear_pressed() -> void:
	var md = get_parent().get_node("Modelos")
	var tipo = $NuevoCredencial/TipoCredencial/OptTipoCredencial.get_selected_id()
	md.get_node("Credenciales").create(my_propagado, tipo)

func _on_btn_probar_pressed() -> void:
	var port = $Adquisicion/Huellero/PuertoHuellero/OptPuertoHuellero.get_selected_id()
	if port == 1:
		$Adquisicion/TxtMessage.text = "Dispositivo huellero detectado"
	else:
		$Adquisicion/TxtMessage.text = "Fallo, no hay dispositivo huellero"

func _on_timer_ok_timeout() -> void:
	$Adquisicion/TxtMessage.text = "Se han guardado las credenciales"
