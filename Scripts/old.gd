extends Control

	for zon in $Modelo.zonas:
		$Salones/PanelFiltros/OptSalonesZona.add_item(zon["nombre"])
		$Horarios/PanelFiltros/OptHorariosZona.add_item(zon["nombre"])
	for sal in $Modelo.salones:
		$Horarios/PanelFiltros/OptHorariosSalones.add_item(sal["nombre"])
	for usr in $Modelo.usuarios:
		if usr["rol_id"] > 1:
			continue
		$Horarios/PanelFiltros/OptHorariosInstructores.add_item(usr["nombre"])
	# pintar salones
	for sal in $Modelo.salones:
		var r = REG_SAL.instantiate()
		$Salones/PanelSalones/TablaSalones/Registros.add_child(r)
		r.get_node("TxtId").text = str(sal["id"])
		r.get_node("TxtSalon").text = str(sal["nombre"])
		r.get_node("TxtZona").text = $Modelo.get_nombre($Modelo.zonas, sal["zona_id"])
		r.get_node("TxtCentro").text = $Modelo.get_nombre($Modelo.centros, sal["centro_id"])
		r.get_node("TxtSede").text = $Modelo.get_nombre($Modelo.sedes, sal["sede_id"])
		r.get_node("TxtOk").text = sal["ok"]
		r.seleccionado.connect(preguntaItem)
