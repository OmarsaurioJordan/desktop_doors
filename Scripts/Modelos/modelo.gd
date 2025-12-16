extends Node

var id_salones = 0
var id_zonas = 0
var id_asignaciones = 0
var salones = []
var asignaciones = []
var sedes = [
	{"id": 1, "nombre": "Salomia", "direccion": "calle 5 # 1"},
	{"id": 2, "nombre": "Norte", "direccion": "av 6ta nte # 3"},
	{"id": 3, "nombre": "Pondaje", "direccion": "simón con 43"}
]
var centros = [
	{"id": 0, "nombre": "N/A"},
	{"id": 1, "nombre": "CEAI"},
	{"id": 2, "nombre": "ASTIN"},
	{"id": 3, "nombre": "CGTS"},
	{"id": 4, "nombre": "CDTI"}
]
var zonas = []

var namezonas = [
	"Edificio", "Pasillo", "Clúster", "Zona", "Campo", "Agrupamiento",
	"Espacio", "Patio", "Pabellón", "Central", "Piso", "Reserva"
]
var atibutoszona = [
	"informático", "tecnológico", "iluminado", "azul", "rojo", "verde",
	"blanco", "amarillo", "natural", "bienestar", "industrial", "franco"
]
var namesalon = [
	"Sala", "Salón", "Ambiente", "Taller", "Laboratorio", "Ala",
	"Informática", "Cómputo", "100", "200", "300", "Bodega",
	"A", "B", "C", "D", "Espacio", "Habitáculo", "Auditorio"
]

func create_salon_azar() -> int:
	id_salones += 1
	var s = {
		"id": id_salones,
		"nombre": item_azar(namesalon) + "-" + clave_azar(2),
		"zona_id": item_azar(zonas)["id"] if randf() < 0.5 else 1,
		"centro_id": item_azar(centros)["id"],
		"sede_id": item_azar(sedes)["id"],
		"ok": "si" if randf() > 0.2 else "No"
	}
	salones.append(s)
	return s["id"]

func create_zona_azar() -> int:
	id_zonas += 1
	var z = {
		"id": id_zonas,
		"nombre": item_azar(namezonas) + " " + item_azar(atibutoszona),
		"sede_id": item_azar(sedes)["id"]
	}
	if id_zonas == 1:
		z["nombre"] = "N/A"
		z["sede_id"] = -1
	zonas.append(z)
	return z["id"]
