extends Panel

func clear() -> void:
	$Crear/LinNombre1.text = ""
	$Crear/LinNombre2.text = ""
	$Crear/LinApellido1.text = ""
	$Crear/LinApellido2.text = ""
	$Crear/LinCedula.text = ""
	$Crear/TxtMessage.text = ""
	$Crear/Nuevorol/OptNuevoRol.select(0)

func _on_btn_volver_pressed() -> void:
	get_parent().set_vista("Usuarios")
	clear()

func _on_btn_registrar_pressed() -> void:
	var n1 = $Crear/LinNombre1.text
	var n2 = $Crear/LinNombre2.text
	var a1 = $Crear/LinApellido1.text
	var a2 = $Crear/LinApellido2.text
	var cc = $Crear/LinCedula.text
	var rol = $Crear/Nuevorol/OptNuevoRol.get_selected_id()
	if n1 == "" or a1 == "" or a2 == "" or cc == "":
		$Crear/TxtMessage.text = "Debe ingresar los campos obligatorios"
	else:
		var id = get_parent().get_node("Modelos/Usuarios").create(n1, n2, a1, a2, cc, rol)
		if id != -1:
			get_parent().get_node("Usuarios").buscar_cedula(cc)
			get_parent().set_vista("Usuarios")
			clear()
		else:
			$Crear/TxtMessage.text = "La cédula ya está registrada"
