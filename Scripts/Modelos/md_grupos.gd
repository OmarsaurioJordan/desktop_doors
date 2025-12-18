extends Node

var id_key = -1
var data = []

const NOMBRE1 = [
	"Semillero", "Asociación", "Expertos", "Profesores", "Instructores",
	"Contratistas", "Estimulados", "Equipo", "Desarrolladores", "Líderes"
]
const NOMBRE2 = [
	"industrial", "de diseño", "investigativo", "emprendedor", "especial",
	"psicología", "matemático", "evaluador", "para lectura", "documental"
]

@onready var md = get_parent()

func _ready() -> void:
	create("N/A")

# funciones de creacion de nuevos registros

func create_azar() -> int:
	return create(
		md.item_azar(NOMBRE1) + " " + md.item_azar(NOMBRE2)
	)

func create(nombre) -> int:
	for dt in data:
		if nombre == dt["nombre"]:
			return -1
	id_key += 1
	var d = {
		"id": id_key,
		"nombre": nombre,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_grupos(nombre="", con_usuario=0, con_zona=0, con_salon=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if con_usuario != 0: # 1con 2sin
			var usrs = get_num_usuarios(dt["id"])
			if con_usuario == 1 and usrs == 0:
				continue
			elif con_usuario == 2 and usrs != 0:
				continue
		if con_zona != 0: # 1con 2sin
			var zns = get_num_zonas(dt["id"])
			if con_zona == 1 and zns == 0:
				continue
			elif con_zona == 2 and zns != 0:
				continue
		if con_salon != 0: # 1con 2sin
			var slns = get_num_salones(dt["id"])
			if con_salon == 1 and slns == 0:
				continue
			elif con_salon == 2 and slns != 0:
				continue
		res.append(dt)
	return res

func get_num_usuarios(centro_id: int) -> int:
	return 0 # Tarea contar usuarios asociados al grupo

func get_num_zonas(centro_id: int) -> int:
	return 0 # Tarea contar zonas asociadas al grupo

func get_num_salones(centro_id: int) -> int:
	return 0 # Tarea contar salones asociados al grupo

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
