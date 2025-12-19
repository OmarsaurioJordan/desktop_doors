extends Node

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create(0)

# funciones de creacion de nuevos registros

func create_azar(grupo_id: int):
	var zonas = md.get_node("Zonas").get_all()
	var num = md.item_azar([0, 1, 1, 1, 1, 2, 2, 2, 3, 4])
	for i in range(num):
		create(grupo_id, md.item_azar(zonas)["id"])

func create(grupo_id, zona_id=0) -> int:
	var p = busca_permiso(grupo_id, zona_id)
	if p != -1:
		data[p]["activo"] = true
		get_parent().actualizacion.emit()
		return data[p]["id"]
	id_key += 1
	var d = {
		"id": id_key,
		"grupo_id": grupo_id,
		"zona_id": zona_id,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

func permiso_switch(grupo_id, zona_id=0) -> void:
	var i = busca_permiso(grupo_id, zona_id)
	if i != -1:
		data[i]["activo"] = not data[i]["activo"]
		get_parent().actualizacion.emit()
	else:
		create(grupo_id, zona_id)

# funciones de busqueda con filtros

func busca_permiso(grupo_id, zona_id=0) -> int:
	for i in range(data.size()):
		if data[i]["id"] == 0:
			continue
		if data[i]["grupo_id"] != grupo_id:
			continue
		if data[i]["zona_id"] == zona_id:
			return i
	return -1

func get_permiso(grupo_id, zona_id=0) -> bool:
	var i = busca_permiso(grupo_id, zona_id)
	if i != -1:
		return data[i]["activo"]
	return false

func busca_elementos(grupo_id) -> Array:
	var zonas = md.get_node("Zonas")
	var res = []
	for dt in data:
		if dt["id"] == 0 or not dt["activo"]:
			continue
		if dt["grupo_id"] != grupo_id:
			continue
		res.append(zonas.get_data(dt["zona_id"]))
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

func get_nombre(id: int) -> String:
	return md.get_nombre(data, id)

func get_nombres() -> Array:
	return md.get_nombres(data)
