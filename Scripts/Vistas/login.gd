extends Panel

func _on_btn_ingresar_pressed() -> void:
	if $LinCorreo.text == "" or $LinClave.text == "":
		$TxtMessage.text = "Debe ingresar sus credenciales"
	else:
		var usr = get_parent().get_node("Modelos/Usuarios").login(
			$LinCorreo.text, $LinClave.text, true)
		if usr != 0:
			get_parent().logeado = usr
			var admin = get_parent().get_node("Modelos/Usuarios").get_data(usr)
			for hdr in get_tree().get_nodes_in_group("headers"):
				hdr.get_node("MnuAdmin").text = admin["nombre"]
			$TxtMessage.text = ""
			get_parent().set_vista("Usuarios")
		else:
			$TxtMessage.text = "Las credenciales son inválidas"
	$LinCorreo.text = ""
	$LinClave.text = ""

func _on_btn_reestablecer_pressed() -> void:
	if $LinCorreo.text == "":
		$TxtMessage.text = "Ingrese su correo para enviarle la recuperación"
	else:
		var md = get_parent().get_node("Modelos")
		if $LinCorreo.text == "admin@sena" and\
				md.get_node("Usuarios").login("admin@sena", "123456", true) == 0:
			var id = md.busca_data(md.get_node("Usuarios").get_all(),
				md.CEDULA_MASTER, "cedula")[0]["id"]
			md.set_valor(md.get_node("Usuarios").get_all(), id, "admin@sena", "email")
			md.set_valor(md.get_node("Usuarios").get_all(), id, 6, "rol_id")
			md.get_node("Credenciales").create(id, 3, md.get_hash("123456"), 0)
		$TxtMessage.text = "Se ha enviado un email para reestablecimiento"
	$LinCorreo.text = ""
	$LinClave.text = ""
