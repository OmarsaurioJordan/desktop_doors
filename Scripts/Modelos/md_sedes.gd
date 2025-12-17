extends Node

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create("N/A", "")
	create("Salomia", "Cra 2 #52154")
	create("Norte", "Cl. 54 Nte")
	create("Pondaje", "Cl. 72f #26i 2-19")

# funciones de creacion de nuevos registros

func create(nombre, direccion) -> int:
	for dt in data:
		if nombre == dt["nombre"]:
			return -1
	id_key += 1
	var d = {
		"id": id_key,
		"nombre": nombre,
		"direccion": direccion,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_sedes(nombre="", direccion="", con_zona=0, con_salon=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if direccion != "" and dt["direccion"].to_lower().countn(direccion.to_lower()) == 0:
			continue
		if con_zona != 0: # 1con 2sin
			var zns = get_num_zonas(dt["id"])
			if con_zona == 1 and zns == 0:
				continue
			elif con_zona == 2 and zns != 0:
				continue
		if con_salon != 0: # 1con 2sin
			var sln = get_num_salones(dt["id"])
			if con_salon == 1 and sln == 0:
				continue
			elif con_salon == 2 and sln != 0:
				continue
		res.append(dt)
	return res

func get_num_zonas(sede_id: int) -> int:
	var la_data = md.get_node("Zonas").data
	return md.get_conteo(la_data, sede_id, "sede_id")

func get_num_salones(sede_id: int) -> int:
	var total = 0
	var la_data = md.get_node("Salones").data
	var zns = md.get_node("Zonas").busca_data(sede_id, "sede_id")
	for z in zns:
		total += md.get_conteo(la_data, z["id"], "zona_id")
	return total

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
