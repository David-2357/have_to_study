# Interfaz y experiencia de usuario

## 1. Referencia de diseño

Este documento deriva requisitos de las imágenes entregadas en el archivo de diseños. La dirección visual común es:
- Aplicación móvil con fondo claro ligeramente azulado.
- Superficies tipo tarjeta, esquinas redondeadas y separación generosa.
- Color principal terracota/rojo oscuro para acciones primarias.
- Colores auxiliares por asignatura y tipo de compromiso.
- Tipografía sans-serif de alta legibilidad.
- Barra inferior con cuatro destinos: Pomodoro, Estudios, Calendario y Estadísticas.
- Cabecera con título/contexto, acceso a Ajustes y Perfil en pantallas principales.

Los colores exactos, fuentes y medidas deben formalizarse como tokens de diseño durante la implementación; no se deducen valores exactos de píxeles de las imágenes.

## 2. Navegación

### Navegación inferior
- Pomodoro.
- Estudios.
- Calendario.
- Estadísticas.

### Destinos secundarios
- Ajustes.
- Perfil de estudiante.
- Formularios/modales para crear asignatura o compromiso.
- Detalle de asignatura.
- Detalle expandido de compromiso.

## 3. Pomodoro — pantalla principal

Diseño de referencia: `Pomodoro - Temporizador Principal.png`.

Orden de contenido:
1. Cabecera con marca, acceso a ajustes y perfil.
2. Contexto académico/etiqueta de enfoque.
3. Tarjeta del compromiso o asignatura seleccionada.
4. Etiqueta de fase actual.
5. Temporizador circular prominente.
6. Indicador de ciclo y bloques hasta descanso largo.
7. Controles: reiniciar, iniciar/pausar y avanzar al descanso (si se permite).
8. Resumen de actividad diaria/tiempo acumulado, sujeto al alcance MVP.

Estados de pantalla:
- En reposo: botón «Iniciar enfoque».
- Concentración activa: temporizador y botón «Pausar concentración».
- Pausado: botón «Reanudar».
- Descanso: etiqueta del tipo de descanso y controles pertinentes.
- Finalizado: feedback breve, transición y actualización del ciclo.

Selector de asignatura/compromiso debe dejar claro el contexto fijado para la sesión. El control de avance manual debe seguir las reglas del temporizador y evitar crear registros falsos.

## 4. Sesión en curso

Diseño de referencia: `Sesión de Estudio en Curso.png`.

La pantalla o presentación ampliada de sesión incluye:
- Asignatura, estado y compromiso asociado.
- Indicador de concentración activa.
- Temporizador circular grande.
- Ciclo actual.
- Acciones de reset, pasar al descanso, pausar y cancelar.
- Tarjeta inferior con título del compromiso y progreso de bloques, cuando exista.

El «pasar al descanso» es una acción manual explícita; si se incluye, debe finalizar/cancelar el bloque actual según una regla claramente etiquetada y no contabilizarlo como bloque completado si no terminó naturalmente.

## 5. Estudios / asignaturas

Diseño de referencia: `Asignaturas y Entregas.png`.

Contenido:
- Título «Asignaturas» y acción «Nueva».
- Selector entre listado de asignaturas y pendientes.
- Búsqueda por nombre o código.
- Filtros: todas, con compromisos, archivadas.
- Tarjetas de asignatura con color, nombre, código, tiempo acumulado, última sesión y resumen de compromisos.
- Grupos plegables de asignaturas inactivas/archivadas y finalizadas si se implementan los estados extendidos.

La tarjeta de asignatura debe abrir su detalle.

## 6. Crear asignatura

Diseño de referencia: `Crear Asignatura.png`.

Campos visuales contemplados:
- Nombre.
- Código opcional.
- Periodo/semestre.
- Icono temático.
- Color.
- Ritmo Pomodoro/meta semanal y duración por bloque aparecen en la referencia, pero no se implementan en el MVP; mantenerlos fuera del formulario inicial para evitar complejidad.

Acción primaria: guardar. Validar el nombre obligatorio.

## 7. Detalle de asignatura

Diseño de referencia: `Detalle de Asignatura.png`.

Contenido:
- Identidad de asignatura: código, nombre, color y estado.
- Resumen de tiempo dedicado, bloques Pomodoro y compromisos pendientes.
- Acción para iniciar un Pomodoro asociado a la materia.
- Próximo compromiso destacado.
- Selector entre compromisos e historial.
- Lista de compromisos con tipo, fecha y progreso asociado.

En MVP, no mostrar métricas de preparación subjetiva ni datos no respaldados por registros.

## 8. Pendientes y entregas

Diseños de referencia:
- `Pendientes y Entregas.png`
- `Pendientes - Tarjeta Expandida con Estadísticas.png`
- `Nuevo Pendiente - Modal.png`

Listado:
- Título y acción «Nuevo».
- Tabs Estudios/Pendientes o una navegación equivalente.
- Búsqueda.
- Filtros por todos, exámenes, entregas y otros tipos.
- Tarjetas ordenadas por vencimiento.
- Badge de tipo y tiempo restante.
- Asignatura y fecha/hora.
- Objetivo y progreso de Pomodoros, si se configuraron.
- Expandir tarjeta para ver métricas derivadas y acciones.

Formulario:
- Tipo de actividad.
- Asignatura vinculada.
- Título.
- Notas/temario opcionales.
- Fecha límite.
- Toggle para incluir hora.
- Objetivo de Pomodoros opcional.
- Guardar compromiso y descartar.

En el MVP no incluir ponderación de nota, prioridad crítica, fijación inteligente, notificaciones ni localización/aula.

## 9. Calendario

Diseño de referencia: `Calendario de Asignaturas y Actividades.png`.

Contenido:
- Cabecera Calendario y acción crear.
- Navegación mensual, control «Hoy».
- Rejilla de días de semana.
- Marcadores de actividad diferenciados por tipo.
- Leyenda de colores/tipos.
- Sección «Día seleccionado» con tarjetas de compromisos.
- Acciones contextuales para iniciar estudio si el compromiso lo permite.

La selección del día no debe perderse al abrir/cerrar un detalle, salvo que el usuario navegue a otra fecha.

## 10. Estadísticas

Diseño de referencia: `Estadísticas de Estudio.png`.

Estructura:
- Selector «Esta semana», «Este mes», «Global».
- Tarjetas para tiempo total y ciclos completados.
- En MVP, promedio diario como indicador adicional.
- Gráfico de barras del ritmo de los últimos siete días.
- Distribución por asignatura con barras horizontales y valores de tiempo.

Los bloques de eficiencia, metas cumplidas, zona de oro/productividad por franja y análisis explicativo se consideran versiones futuras. No deben presentarse con datos simulados.

## 11. Perfil de estudiante

Diseño de referencia: `Perfil de Usuario.png`.

Contenido objetivo:
- Nombre y avatar.
- Carrera/titulación y semestre/ciclo, opcionales.
- Resumen académico de métricas.
- Lista de asignaturas activas.
- Sección de privacidad local y backup.

MVP: perfil local sencillo y sin métricas académicas avanzadas ni backup.

## 12. Ajustes

Diseño de referencia: `Ajustes.png`.

Agrupaciones visuales:
- Privacidad local.
- Meta diaria.
- Temporizador de enfoque.
- Sonidos y notificaciones.
- Almacenamiento y copias locales.
- Preferencias de sistema.

MVP: implementar duraciones/ciclos Pomodoro, auto-inicios, tema y preferencias horarias básicas. Dejar fuera metas, notificaciones de inactividad, recordatorios locales, exportación/importación, borrado completo y sonidos configurables extensos.

## 13. Cierre de curso

Diseño de referencia: `Cierre de Curso - Clasificación de Asignaturas.png`.

El flujo visual clasifica asignaturas como aprobadas, repetir o inactivas y muestra un balance antes de confirmar el cierre. Se reserva para una versión futura. No añadir accesos a este flujo en el MVP.

## 14. Accesibilidad y estados

- Iconos acompañados de etiquetas o semántica accesible.
- El color no es el único indicador de tipo, estado o fase.
- Contraste suficiente y texto escalable.
- Controles táctiles adecuados.
- Estados vacíos para falta de asignaturas, compromisos o sesiones.
- Estados de carga y error para operaciones asíncronas.
- Confirmación para cancelaciones con progreso y acciones destructivas.
