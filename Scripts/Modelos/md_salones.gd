extends Node

var id_key = -1
var data = []

const NOMBRE = [
	"Informática", "Ala", "Bodega", "Sala", "Salón", "Auditorio",
	"A", "B", "C", "D", "100", "200", "300", "400", "Espacio", "Ambiente",
	"Taller", "Laboratorio", "Almacén", "Zótano", "Mirador", "Garage"
]

@onready var md = get_parent()

func _ready() -> void:
	create("N/A", 0, 0)

# funciones de creacion de nuevos registros

func create_azar() -> int:
	var centros = md.get_node("Centros").get_all()
	var zonas = md.get_node("Zonas").get_all()
	var centro = md.item_azar(centros)
	if randf() < 0.15:
		centro = centros[0]
	return create(
		md.item_azar(NOMBRE) + "-" + str(md.clave_azar(2)),
		md.item_azar(zonas)["id"],
		centro["id"]
	)

func create_auto() -> int:
	return create("*** nuevo ***", 0, 0)

func create(nombre, zona_id, centro_id) -> int:
	for dt in data:
		if nombre == dt["nombre"]:
			return -1
	id_key += 1
	var d = {
		"id": id_key,
		"nombre": nombre,
		"zona_id": zona_id,
		"centro_id": centro_id,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_salones(nombre="", centro_id=0, zona_id=0, sede_id=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if centro_id != 0 and dt["centro_id"] != centro_id:
			continue
		if zona_id != 0 and dt["zona_id"] != zona_id:
			continue
		if sede_id != 0 and md.get_node("Zonas").get_data(dt["zona_id"])["sede_id"] != sede_id:
			continue
		res.append(dt)
	return res

# funciones genericas heredadas del modelo general

func get_all() -> Array:
	return data.slice(1)

func busca_data(valor, tipo="") -> Array:
	return md.busca_data(data, valor, tipo)

func get_data(id: int) -> Dictionary:
	return md.get_data(data, id)

func set_valor(id: int, valor, tipo="") -> void:
	md.set_valor(data, id, valor, tipo)
	# Tarea dependencia entre zona y sede, cuidado con oscilaciones loop

func get_nombre(id: int) -> String:
	return md.get_nombre(data, id)

func get_nombres() -> Array:
	return md.get_nombres(data)
