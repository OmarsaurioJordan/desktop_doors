extends Node

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create(0)

# funciones de creacion de nuevos registros

func create_azar(usuario_id: int):
	if randf() < 0.2:
		var grupos = md.get_node("Grupos").data
		var num = md.item_azar([1, 1, 1, 1, 2, 2, 3])
		for i in range(num):
			create(usuario_id, 0, 0, md.item_azar_no_cero(grupos)["id"])
	if randf() < 0.3:
		var zonas = md.get_node("Zonas").data
		var num = md.item_azar([1, 1, 1, 2, 2, 2, 3, 3, 4, 5])
		for i in range(num):
			create(usuario_id, md.item_azar_no_cero(zonas)["id"], 0, 0)
	if randf() < 0.5:
		var salones = md.get_node("Salones").data
		var num = randi_range(1, 10)
		for i in range(num):
			create(usuario_id, 0, md.item_azar_no_cero(salones)["id"], 0)

func create(usuario_id, zona_id=0, salon_id=0, grupo_id=0) -> int:
	if not is_un_tipo(zona_id, salon_id, grupo_id):
		return 0
	var p = busca_permiso(usuario_id, zona_id, salon_id, grupo_id)
	if p != -1:
		data[p]["activo"] = true
		get_parent().actualizacion.emit()
		return data[p]["id"]
	id_key += 1
	var d = {
		"id": id_key,
		"usuario_id": usuario_id,
		"zona_id": zona_id,
		"salon_id": salon_id,
		"grupo_id": grupo_id,
		"activo": true
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

func permiso_switch(usuario_id, tipo="", valor_id=0) -> void:
	var i = -1
	match tipo:
		"zona_id":
			i = busca_permiso(usuario_id, valor_id, 0, 0)
		"salon_id":
			i = busca_permiso(usuario_id, 0, valor_id, 0)
		"grupo_id":
			i = busca_permiso(usuario_id, 0, 0, valor_id)
	if i != -1:
		data[i]["activo"] = not data[i]["activo"]
		get_parent().actualizacion.emit()
	else:
		match tipo:
			"zona_id":
				create(usuario_id, valor_id, 0, 0)
			"salon_id":
				create(usuario_id, 0, valor_id, 0)
			"grupo_id":
				create(usuario_id, 0, 0, valor_id)

# funciones de busqueda con filtros

func busca_permiso(usuario_id, zona_id=0, salon_id=0, grupo_id=0) -> int:
	for i in range(data.size()):
		if data[i]["id"] == 0:
			continue
		if data[i]["usuario_id"] != usuario_id:
			continue
		if zona_id != 0 and data[i]["zona_id"] == zona_id:
			return i
		if salon_id != 0 and data[i]["salon_id"] == salon_id:
			return i
		if grupo_id != 0 and data[i]["grupo_id"] == grupo_id:
			return i
	return -1

func get_permiso(usuario_id, tipo="", valor_id=0) -> bool:
	var i = -1
	match tipo:
		"zona_id":
			i = busca_permiso(usuario_id, valor_id, 0, 0)
		"salon_id":
			i = busca_permiso(usuario_id, 0, valor_id, 0)
		"grupo_id":
			i = busca_permiso(usuario_id, 0, 0, valor_id)
	if i != -1:
		return data[i]["activo"]
	return false

func busca_elementos(usuario_id, tablename: String, tipo: String) -> Array:
	var zonas = md.get_node(tablename)
	var res = []
	for dt in data:
		if dt["id"] == 0 or not dt["activo"]:
			continue
		if dt["usuario_id"] != usuario_id:
			continue
		if dt[tipo] != 0:
			res.append(zonas.get_data(dt[tipo]))
	return res

func busca_zonas(usuario_id) -> Array:
	return busca_elementos(usuario_id, "Zonas", "zona_id")

func busca_grupos(usuario_id) -> Array:
	return busca_elementos(usuario_id, "Grupos", "grupo_id")

func busca_salones(usuario_id) -> Array:
	return busca_elementos(usuario_id, "Salones", "salon_id")

func is_un_tipo(zona_id=0, salon_id=0, grupo_id=0) -> bool:
	if zona_id != 0 and (salon_id != 0 or grupo_id != 0):
		return false
	if salon_id != 0 and (zona_id != 0 or grupo_id != 0):
		return false
	if grupo_id != 0 and (salon_id != 0 or zona_id != 0):
		return false
	return true

func get_salon_permiso(usuario_id, salon_id) -> bool:
	if get_permiso(usuario_id, "salon_id", salon_id):
		return true
	var zona_id = md.get_valor(md.get_node("Salones").data, salon_id, "zona_id", 0)
	if get_permiso(usuario_id, "zona_id", zona_id):
		return true
	# Tarea dar permiso si horario
	# Tarea dar permiso si grupo
	return false

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
