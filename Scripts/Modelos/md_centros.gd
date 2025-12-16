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
			pass
		if con_salon != 0:
			pass
		res.append(dt)
	return res

func get_num_usuarios(centro_id: int) -> int:
	var la_data = md.get_node("Usuarios").data
	return md.get_conteo(la_data, centro_id, "centro_id")

# funciones genericas heredadas del modelo general

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
