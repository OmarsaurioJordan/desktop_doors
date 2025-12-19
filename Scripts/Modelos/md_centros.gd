extends Node

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create("N/A", "")
	create("CEAI", "Centro de Electricidad y Automatización Industrial")
	create("ASTIN", "Centro Nacional de Asistencia Técnica a la Industria")
	create("CGTS", "Centro de Gestión Tecnológica de Servicios")
	create("CDTI", "Centro de Diseño Tecnológico Industrial")

# funciones de creacion de nuevos registros

func create_auto() -> int:
	return create("*** nuevo ***", "")

func create(nombre, descripcion) -> int:
	for dt in data:
		if nombre == dt["nombre"]:
			return -1
	id_key += 1
	var d = {
		"id": id_key,
		"nombre": nombre,
		"descripcion": descripcion,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_centros(nombre="", con_usuario=0, con_zona=0, con_salon=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0 and\
				dt["descripcion"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if con_usuario != 0: # 1con 2sin
			var usrs = get_num_usuarios(dt["id"])
			if con_usuario == 1 and usrs == 0:
				continue
			elif con_usuario == 2 and usrs != 0:
				continue
		if con_zona != 0:
			var zns = get_num_zonas(dt["id"])
			if con_usuario == 1 and zns == 0:
				continue
			elif con_usuario == 2 and zns != 0:
				continue
		if con_salon != 0:
			var slns = get_num_salones(dt["id"])
			if con_usuario == 1 and slns == 0:
				continue
			elif con_usuario == 2 and slns != 0:
				continue
		res.append(dt)
	return res

func get_num_usuarios(centro_id: int) -> int:
	var la_data = md.get_node("Usuarios").get_all()
	return md.get_conteo(la_data, centro_id, "centro_id")

func get_num_salones(centro_id: int) -> int:
	var la_data = md.get_node("Salones").get_all()
	return md.get_conteo(la_data, centro_id, "centro_id")

func get_num_zonas(centro_id: int) -> int:
	var zns = []
	var la_data = md.get_node("Zonas").get_all()
	var sln = md.get_node("Salones").busca_data(centro_id, "centro_id")
	for s in sln:
		if s["zona_id"] == 0:
			continue
		var n = md.get_nombre(la_data, s["zona_id"])
		if not n in zns:
			zns.append(n)
	return zns.size()

# funciones genericas heredadas del modelo general

func get_all() -> Array:
	return data.slice(1)

func busca_data(valor, tipo="") -> Array:
	return md.busca_data(data, valor, tipo)

func get_data(id: int) -> Dictionary:
	return md.get_data(data, id)

func set_valor(id: int, valor, tipo="") -> void:
	md.set_valor(data, id, valor, tipo)

func get_nombre(id: int) -> String:
	return md.get_nombre(data, id)

func get_nombres() -> Array:
	return md.get_nombres(data)
