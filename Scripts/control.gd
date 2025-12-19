extends Control

const DEBUG = false # para ingresar instantaneamente sin login

var logeado = 0 # id de usuario con login

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

func _on_menu_item(id: int):
	match id:
		0: # ir a la configuracion
			pass # Tarea hacer menu de opciones
		1: # salir, logout
			set_vista("Login")

func set_vista(vista: String) -> void:
	for vis in get_tree().get_nodes_in_group("vistas"):
		vis.visible = vis.name == vista

# funcion general para cargar items en selector por grupo
func set_selector_grupo(nombres: Array, grupo="", defecto=-1) -> void:
	var limpiar: bool
	for opt in get_tree().get_nodes_in_group(grupo):
		if opt.get_item_count() == nombres.size():
			limpiar = false
			for i in range(opt.get_item_count()):
				if opt.get_item_text(i) != nombres[i]:
					limpiar = true
					break
			if not limpiar:
				if defecto != -1:
					opt.select(defecto)
				continue
		opt.clear()
		for n in nombres:
			opt.add_item(n)
		if defecto != -1:
			opt.select(defecto)
		else:
			opt.select(0)

func _on_timer_busqueda_timeout() -> void:
	$Usuarios._on_btn_buscar_pressed()
	$Centros._on_btn_buscar_pressed()
	$Grupos._on_btn_buscar_pressed()
	$Sedes._on_btn_buscar_pressed()
	$Zonas._on_btn_buscar_pressed()
	$Salones._on_btn_buscar_pressed()
	$Horarios._on_btn_buscar_pressed()
