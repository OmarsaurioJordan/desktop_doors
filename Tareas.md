# Tareas

## Prioritarias

- Obtener grupos por zonas, mostrar el número y navegar a búsqueda de grupos.

- Navegar a salones desde zonas, desde el indicador de número de salones.

- Navegar desde sedes a zonas y ambientes, segun número de estos pulsados.

- Navegar hasta zonas y salones desde centros, según número de estos pulsados.

- Filtrar usuarios y salones por selector de centro y sede en interfaz de horario.

- Evitar que campos que no deben repetirse se repitan al editar, ejemplo, nombres únicos.

- En horarios, verificar que fecha fin siempre sea mayor a inicial, y que se cumpla la etiqueta que dice si está actualmente activa respecto al momento actual.

## Documento

- Actualizar la base de datos MR y MER para que coincida con Godot.

- Modificar el Arduino para permitir que la puerta quede abierta al dejar el salón enclavado en modo permisivo, se requiere cambiar 2 líneas de código nomás.

- Terminar el marco teórico, hablando de diferéntes métodos y tecnologías asociados.

- Agregar los mockups de diseño con criterios de diseño al documento.

## Futuro

- Debe poder detectar y advertir cuando dos horarios se cruzan, al asignar salones, es fundamental.

- Botón de ayuda debe poder pulsarse, quizá muestre menú desplegable, otra página, web, emergente.

- Guardado local en txt de los datos de testeo.

- Implementar el sistema de auditorias para guardar acciónes administrativas.

- Implementar sistema de historial de accesos para llevar un registro.

- Con el historial de accesos obtener métricas de el cumplimiento de horarios.

- Hacer la interfaz responsiva usando los layouts y configuración de escalamiento.

- Conectar el Godot con Arduino mediante el puerto Serie, para emular dispositivo de huellero.

- Codificar en Godot para que se puedan obtener datos de una DB con SQL, por ejemplo del servidor XAMPP en la DB MariaDB

- Modificar el sistema de horarios para permitir horas exactas, no bloques enteros.

- Modificar el sistema de horarios para que uno tenga varios salones (¿asignaturas CRUD?) asociados.

- Agregar conexión con los otros módulos: el de observación de información del sistema, al que pueden acceder otros usuarios, para ver historial de cumplimiento, auditorías, horarios, etc (el mockup ya lo hizo alguien en el semillero), y el módulo responsivo a móvil para obtener y hacer observaciónes del ambiente. Este último es un proyecto paralelo al de las puertas.

## Notas

- Cuando se coloquen datos en los selectores / options, y deban ser filtrados, por ejemplo, usuarios filtrados por centro, deben colocarse todos, ya que el selector autoasigna IDs, pero en el selector se inhabilita los que no cumplan con el filtro.

- Algunas funciones como las recurrentes al final de los modelos, pueden evitar reescribirse creando clases de metodología POO sobre los nodos.
