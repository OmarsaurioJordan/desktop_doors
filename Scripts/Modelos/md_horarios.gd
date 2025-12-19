extends Node

const DIA = 86400

var id_key = -1
var data = []

@onready var md = get_parent()

func _ready() -> void:
	create(0, 0)

# funciones de creacion de nuevos registros

func create_azar() -> int:
	var usuarios = md.get_node("Usuarios").busca_profesores()
	var salones = md.get_node("Salones").get_all()
	var date = Time.get_unix_time_from_system() + DIA * 30 * 3 - randi_range(DIA, DIA * 30 * 12)
	return create(
		md.item_azar(usuarios)["id"],
		md.item_azar(salones)["id"],
		date,
		date - randi_range(DIA * 7, DIA * 30 * 3),
		horario_azar()
	)

func create_auto() -> int:
	return create(0, 0)

func create(usuario_id, salon_id, inicio=0, final=0, horario="") -> int:
	id_key += 1
	var d = {
		"id": id_key,
		"usuario_id": usuario_id,
		"salon_id": salon_id,
		"inicio": inicio,
		"final": final,
		"horario": "".pad_zeros(7 * 4) if horario == "" else horario
	}
	data.append(d)
	get_parent().actualizacion.emit()
	return d["id"]

# funciones de busqueda con filtros

func busca_horarios(usuario_id=0, salon_id=0, centro_id=0, sede_id=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if usuario_id != 0 and dt["usuario_id"] != usuario_id:
			continue
		if salon_id != 0 and dt["salon_id"] != salon_id:
			continue
		var cnt_id = md.get_node("Usuarios").get_data(dt["usuario_id"])["centro_id"]
		if centro_id != 0 and cnt_id != centro_id:
			continue
		var zna_id = md.get_node("Salones").get_data(dt["salon_id"])["zona_id"]
		var sde_id = md.get_node("Zonas").get_data(zna_id)["sede_id"]
		if sede_id != 0 and sde_id != sede_id:
			continue
		res.append(dt)
	return res

# herramientas extra de el horario en rejilla

func horario_azar() -> String:
	var res = ""
	for i in range(5):
		res += "0" if randf() > 0.4 else "1" # mannanas
	res += "0" if randf() > 0.2 else "1" # mannana sabado
	res += "0" if randf() > 0.01 else "1" # mannana domingo
	for i in range(5):
		res += "0" if randf() > 0.4 else "1" # tardes
	res += "0" if randf() > 0.1 else "1" # tarde sabado
	res += "0" if randf() > 0.01 else "1" # tarde domingo
	for i in range(5):
		res += "0" if randf() > 0.1 else "1" # noches
	res += "0" if randf() > 0.05 else "1" # noche sabado
	res += "0" if randf() > 0.01 else "1" # noche domingo
	for i in range(5):
		res += "0" if randf() > 0.01 else "1" # madrugadas
	res += "0" if randf() > 0.01 else "1" # madrugada sabado
	res += "0" if randf() > 0.01 else "1" # madrugada domingo
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
