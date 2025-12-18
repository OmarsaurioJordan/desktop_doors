extends Node

const ACTIVO = ["--", "|"] # false, true
const CLAVE_INTERNA = "SENA_CEAI_ADSO" # cualquier cosa, para password con md5
const CEDULA_MASTER = "11344"

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
const CREDENCIALES = [
	"Huella",
	"Facial",
	"Tarjeta",
	"Contraseña"
]

signal actualizacion()

func _ready() -> void:
	randomize()
	get_parent().set_selector_grupo(ROLES, "opt_roles")
	get_parent().set_selector_grupo(CREDENCIALES, "opt_credencales")
	# cargar datos artificiales en el modelo de informacion
	call_deferred("carga_por_defecto")

func carga_por_defecto() -> void:
	for i in range(16):
		$Zonas.create_azar()
	for i in range(90):
		$Usuarios.create_azar(i < 3)
	for i in range(80):
		$Salones.create_azar()
	for i in range(25):
		$Grupos.create_azar()
	for i in range(50 * 4):
		$Horarios.create_azar()
	for u in $Usuarios.data:
		$Credenciales.create_azar(u["id"])
	for u in $Usuarios.data:
		$Permisos.create_azar(u["id"])
	# crear al administrador master para acceso
	var i = $Usuarios.create("Admin", "", "Master", "Sena",
		CEDULA_MASTER, 6, 0, clave_azar(6), "admin@sena")
	$Credenciales.create(i, 3, get_hash("123456"), 0)

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
				actualizacion.emit()

func get_valor(data: Array, id: int, tipo="", defecto=""):
	for dt in data:
		if id == dt["id"]:
			return dt[tipo]
	return defecto

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

func get_conteo(data: Array, valor, tipo="") -> int:
	var tot = 0
	for dt in data:
		if valor == dt[tipo]:
			tot += 1
	return tot

func busca_data(data: Array, valor, tipo="") -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if dt[tipo] != valor:
			continue
		res.append(dt)
	return res

# funciones generales como herramientas

func get_hash(valor: String) -> String:
	var clave = CLAVE_INTERNA + valor + CLAVE_INTERNA
	return clave.md5_text()

func clave_azar(total: int) -> String:
	var res = ""
	for i in range(total):
		res += str(randi() % 10)
	return res

func item_azar(arr: Array):
	return arr[randi() % arr.size()]

func item_azar_no_cero(arr: Array):
	return arr[1 + randi() % (arr.size() - 1)]

func get_activo(is_act: bool) -> String:
	return ACTIVO[1] if is_act else ACTIVO[0]
