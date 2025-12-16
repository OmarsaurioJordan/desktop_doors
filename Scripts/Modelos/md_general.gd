extends Node

const ROLES = [
	"N/A", # 0
	"Instructor", # 1
	"Contratista", # 2
	"Funcionario", # 3
	"Aseador", # 4
	"Vigilante", # 5
	"Administrador", # 6
	"Aprendiz", # 7
	"Otro" # 8
]

func _ready() -> void:
	randomize()
	set_opt_rol()

# funcion general para cargar selectores de rol
func set_opt_rol() -> void:
	for opt in get_tree().get_nodes_in_group("opt_roles"):
		opt.clear()
		for rol in ROLES:
			opt.add_item(rol)
		opt.select(0)

# funciones generales para manejo de datos

func get_data(data: Array, id: int) -> Dictionary:
	for dt in data:
		if id == dt["id"]:
			return dt
	return {}

func set_valor(data: Array, id: int, valor, tipo="") -> void:
	if id != 0:
		for dt in data:
			if id == dt["id"]:
				dt[tipo] = valor

func get_nombre(data: Array, id: int) -> String:
	for dt in data:
		if id == dt["id"]:
			return dt["nombre"]
	return ""

func get_nombres(data: Array) -> Array:
	var res = []
	for dt in data:
		res.append(dt["nombre"])
	return res

# funciones generales como herramientas

func clave_azar(total: int) -> String:
	var res = ""
	for i in range(total):
		res += str(randi() % 10)
	return res

func item_azar(arr: Array):
	return arr[randi() % arr.size()]
