extends Node

const DIA = 86400

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create(0, 0)

# funciones de creacion de nuevos registros

func create_azar(usuario_id: int):
	var date: int
	var num = md.item_azar([0, 1, 1, 1, 1, 1, 1, 2, 2, 3])
	var tipo = 0 if randf() < 0.5 else 3
	for i in range(num):
		date = Time.get_unix_time_from_system() - randi_range(DIA * 30, DIA * 30 * 12)
		create(usuario_id, tipo, md.clave_azar(64) if tipo == 0 else md.clave_azar(4), date)

func create(usuario_id, tipo_id, datos="", fecha=0) -> int:
	id_key += 1
	var d = {
		"id": id_key,
		"usuario_id": usuario_id,
		"tipo_id": tipo_id,
		"datos": datos,
		"activo": true,
		"fecha": Time.get_unix_time_from_system() if fecha == 0 else fecha
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func buscar_usuario(usuario_id: int) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if dt["usuario_id"] != usuario_id:
			continue
		res.append(dt)
	return res

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
