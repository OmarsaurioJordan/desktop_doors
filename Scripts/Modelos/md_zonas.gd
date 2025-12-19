extends Node

var id_key = -1
var data = []

const NOMBRE1 = [
	"Campo", "Espacio", "Pabellón", "Edificio", "Bodega", "Ala", "Zona",
	"Corredor", "Pasillo", "Afueras", "Almacén", "Piso", "Nivel"
]
const NOMBRE2 = [
	"informático", "blanco", "azul", "rojo", "verde", "amarillo",
	"tecnológico", "industrial", "este", "oeste", "norte", "sur"
]

@onready var md = get_parent()

func _ready() -> void:
	create("N/A", 0)

# funciones de creacion de nuevos registros

func create_azar() -> int:
	var sedes = md.get_node("Sedes").get_all()
	return create(
		md.item_azar(NOMBRE1) + " " + md.item_azar(NOMBRE2),
		md.item_azar(sedes)["id"]
	)

func create_auto() -> int:
	return create("*** nueva ***", 0)

func create(nombre, sede_id) -> int:
	for dt in data:
		if nombre == dt["nombre"]:
			return -1
	id_key += 1
	var d = {
		"id": id_key,
		"nombre": nombre,
		"sede_id": sede_id,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_zonas(nombre="", sede_id=0, con_grupo=0, con_salon=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if sede_id != 0 and dt["sede_id"] != sede_id:
			continue
		if con_grupo != 0: # 1con 2sin
			var gps = get_num_grupos(dt["id"])
			if con_grupo == 1 and gps == 0:
				continue
			elif con_grupo == 2 and gps != 0:
				continue
		if con_salon != 0: # 1con 2sin
			var sln = get_num_salones(dt["id"])
			if con_salon == 1 and sln == 0:
				continue
			elif con_salon == 2 and sln != 0:
				continue
		res.append(dt)
	return res

func get_num_salones(zona_id: int) -> int:
	var la_data = md.get_node("Salones").get_all()
	return md.get_conteo(la_data, zona_id, "zona_id")

func get_num_grupos(zona_id: int) -> int:
	var total = 0
	# Tarea contar grupos asociados a la zona
	return total

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
