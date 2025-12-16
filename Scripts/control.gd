extends Control

const DEBUG = true # para ingresar instantaneamente sin login

func _ready() -> void:
	randomize()
	# mostrar la primera vista disponible de la aplicacion
	if DEBUG:
		for hdr in get_tree().get_nodes_in_group("headers"):
			hdr.get_node("MnuAdmin").text = "admin_testing@sena"
		set_vista("Usuarios")
	else:
		set_vista("Login")
	# conectar menu buton de header para poder hacer logout
	for hdr in get_tree().get_nodes_in_group("headers"):
		hdr.get_node("MnuAdmin").get_popup().id_pressed.connect(_on_menu_item)
	# conectar menu lateral
	for lme in get_tree().get_nodes_in_group("latmenu"):
		for btn in lme.get_children():
			if btn.name == "Btn" + lme.get_parent().name:
				btn.disabled = true
			btn.pressed.connect(set_vista.bind(btn.name.replace("Btn", "")))
	# cargar datos artificiales en el modelo de informacion
	call_deferred("carga_por_defecto")

func carga_por_defecto() -> void:
	pass

func _on_menu_item(id: int):
	match id:
		0: # ir a la configuracion
			pass
		1: # salir, logout
			set_vista("Login")

func set_vista(vista: String) -> void:
	for vis in get_tree().get_nodes_in_group("vistas"):
		vis.visible = vis.name == vista
