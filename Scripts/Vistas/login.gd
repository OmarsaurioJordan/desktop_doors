extends Panel

func _on_btn_ingresar_pressed() -> void:
	if $LinCorreo.text == "" or $LinClave.text == "":
		$TxtMessage.text = "Debe ingresar sus credenciales"
	elif $LinCorreo.text.count("@") == 1 and $LinCorreo.text.length() >= 3:
		for hdr in get_tree().get_nodes_in_group("headers"):
			hdr.get_node("MnuAdmin").text = $LinCorreo.text
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
		$TxtMessage.text = "Se ha enviado un email para reestablecimiento"
	$LinCorreo.text = ""
	$LinClave.text = ""
