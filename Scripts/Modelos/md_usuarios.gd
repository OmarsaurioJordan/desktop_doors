extends Node

var id_key = -1
var data = []

const NOMBRES_H = [
	"Aurelio", "Armando", "Andy", "Alexander", "Alejandro",
	"Ariel", "Adam", "Adolfo", "Alberto", "Antonio",
	"Boris", "Brandon", "Brayan", "Bruce", "Bart",
	"Carlos", "Camilo", "Christian", "Cesar", "Cory",
	"Cain", "Charly", "Chuck", "Conan", "Clark",
	"Daniel", "Dante", "Dario", "Denis", "Dustin",
	"Ernesto", "Esteban", "Erick", "Emilio", "Efrain",
	"Francisco", "Federico", "Fabio", "Fernando", "Felipe",
	"Gabriel", "Galvin", "German", "Gonzalo", "Gaston",
	"Hector", "Humberto", "Herbert", "Hugo", "Harry",
	"Ignacio", "Izidro", "Ismael", "Ivan", "Isaac",
	"Jose", "John", "Juan", "Jeremias", "Jean",
	"Kevin", "Kenner", "Kenny", "Klaus", "Karin",
	"Luis", "Leonardo", "Lucas", "Leandro", "Leo",
	"Mateo", "Mauricio", "Manuel", "Marcos", "Martin",
	"Michael", "Marino", "Matias", "Merlin", "Max",
	"Norman", "Nicolas", "Nestor", "Nelson", "Nacho",
	"Omar", "Oswaldo", "Oliver", "Orion", "Ovidio",
	"Pablo", "Paco", "Pancho", "Paul", "Pedro",
	"Ramon", "Remi", "Ragnar", "Ramiro", "Rafael",
	"Santiago", "Samuel", "Sebastian", "Stephen", "Salvador",
	"Tomas", "Tadeo", "Teodoro", "Teofilo", "Tulio",
	"Victor", "Vicente", "Vladimir", "Ventura", "Van",
	"Wilfredo", "William", "Waldo", "Wally", "Walter",
	"Xander", "Yael", "Zamir", "Querubin", "Ulises"
]
const NOMBRES_M = [
	"Angy", "Angela", "Alejandra", "Amanda", "Andrea",
	"Ana", "Adriana", "Allison", "Aurora", "Agata",
	"Bonnie", "Bianca", "Barbara", "Bety", "Brenda",
	"Cony", "Camila", "Carolina", "Celeste", "Cindy",
	"Celia", "Catherine", "Cristina", "Coral", "Claudia",
	"Darian", "Diana", "Dafne", "Dora", "Delia",
	"Estefany", "Eliza", "Emily", "Elena", "Esmeralda",
	"Frida", "Florencia", "Fiona", "Fabiola", "Fatima",
	"Guisela", "Gema", "Gloria", "Gabriela", "Ginna",
	"Homura", "Helena", "Hilda", "Heidy", "Harley",
	"Ingrid", "Ines", "Isabella", "Irene", "Iris",
	"Jackie", "Jazmin", "Jade", "Jenny", "Jessica",
	"Karen", "Kimi", "Kala", "Keiko", "Kyoko",
	"Luisa", "Luz", "Luna", "Laura", "Lorena",
	"Maria", "Martha", "Maribel", "Melisa", "Marcela",
	"Marisol", "Melanie", "Miranda", "Monica", "Margarita",
	"Nora", "Nancy", "Nereida", "Natalia", "Nadia",
	"Olivia", "Olga", "Oriana", "Ofelia", "Ovidia",
	"Patricia", "Paula", "Paloma", "Paola", "Priscila",
	"Regina", "Rebeca", "Rocio", "Rosa", "Rubi",
	"Samanta", "Sara", "Susana", "Sonia", "Selina",
	"Tania", "Tamara", "Tatiana", "Teresa", "Trixie",
	"Victoria", "Valentina", "Valery", "Vanessa", "Vania",
	"Wanda", "Wendy", "Willow", "Winny", "Wynona",
	"Ximena", "Yolanda", "Zaira", "Quira", "Ursula"
]
const APELLIDOS = [
	"Acosta", "Aguilar", "Aguirre", "Alonso", "Andrade",
	"Báez", "Ballesteros", "Barrios", "Benítez", "Blanco",
	"Cabrera", "Calderón", "Campos", "Cano", "Carrillo",
	"Delgado", "Díaz", "Domínguez", "Duarte", "Durán",
	"Escalante", "Escobar", "Espinosa", "Estrada", "Echeverría",
	"Fernández", "Figueroa", "Flores", "Fonseca", "Franco",
	"Gálvez", "García", "Gil", "Gómez", "Guerrero",
	"Hernández", "Herrera", "Huerta", "Hurtado", "Huertas",
	"Ibáñez", "Iglesias", "Ibarra", "Izquierdo", "Islas",
	"Jáuregui", "Jiménez", "Juárez", "Jaramillo", "Jordán",
	"Lara", "León", "López", "Luján", "Lozano",
	"Maldonado", "Márquez", "Martínez", "Medina", "Molina",
	"Navarro", "Nieto", "Núñez", "Novoa", "Naranjo",
	"Olivares", "Orozco", "Ortega", "Ortiz", "Oviedo",
	"Pacheco", "Padilla", "Palma", "Pérez", "Ponce",
	"Quevedo", "Quintero", "Quiroga", "Quintana", "Quispe",
	"Ramírez", "Ramos", "Reyes", "Ríos", "Romero",
	"Salazar", "Salinas", "Sánchez", "Sandoval", "Soto",
	"Téllez", "Torres", "Trejo", "Trujillo", "Tovar",
	"Urbina", "Ureña", "Uribe", "Ulloa", "Urdiales",
	"Valdés", "Valencia", "Valenzuela", "Vásquez", "Vega",
	"King", "Walker", "Xu", "Yosa", "Werner",
	"Zambrano", "Zapata", "Zavala", "Zúñiga", "Zárate"
]
const DOMINIOS = [
	"@sena", "@gmail", "@hotmail", "@yahoo", "@outlook"
]

@onready var md = get_parent()

func _ready() -> void:
	create("N/A", "", "", "", "", 0)

# funciones de creacion de nuevos registros

func create_azar(force_admin=false) -> int:
	var nombres = NOMBRES_H if randf() < 0.5 else NOMBRES_M
	var first = md.item_azar(nombres)
	var rol = md.item_azar([1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 5])
	if force_admin:
		rol = 6
	var centro = 0
	if rol == 1 or rol == 2:
		var tot_centros = md.get_node("Centros").data.size() - 1
		centro = 1 + randi() % tot_centros
	return create(
		first,
		md.item_azar(nombres) if randf() < 0.75 else "",
		md.item_azar(APELLIDOS),
		md.item_azar(APELLIDOS),
		md.clave_azar(4),
		rol,
		centro,
		md.clave_azar(6),
		first.to_lower() + md.clave_azar(2) + md.item_azar(DOMINIOS)
	)

func create(n1, n2, a1, a2, cc, rol, centro=0, telefono="", email="") -> int:
	for dt in data:
		if cc == dt["cedula"]:
			return -1
	id_key += 1
	var u = {
		"id": id_key,
		"nombre": n1 + " " + n2 + " " + a1 + " " + a2,
		"cedula": cc,
		"email": email,
		"telefono": telefono,
		"rol_id": rol,
		"centro_id": centro
	}
	for r in range(10):
		u["nombre"] = u["nombre"].replace("  ", " ")
	u["nombre"] = u["nombre"].trim_prefix(" ").trim_suffix(" ")
	data.append(u)
	get_parent().actualizacion.emit()
	return u["id"]

# funciones de busqueda con filtros

func busca_usuarios(nombre="", valor="", tipo="", rol_id=0, centro_id=0) -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if nombre != "" and dt["nombre"].to_lower().countn(nombre.to_lower()) == 0:
			continue
		if valor != "" and tipo != "":
			if dt[tipo] != valor:
				continue
		if rol_id != 0 and dt["rol_id"] != rol_id:
			continue
		if centro_id != 0 and dt["centro_id"] != centro_id:
			continue
		res.append(dt)
	return res

func busca_profesores() -> Array:
	var res = []
	for dt in data:
		if dt["id"] == 0:
			continue
		if dt["rol_id"] > 2:
			continue
		res.append(dt)
	return res

func login(email: String, password: String, is_admin=false) -> int:
	var usuarios = md.busca_data(data, email, "email")
	for usr in usuarios:
		if is_admin:
			if usr["rol_id"] != 6:
				continue
		if md.get_node("Credenciales").login_password(usr["id"], password):
			return usr["id"]
	return 0

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
