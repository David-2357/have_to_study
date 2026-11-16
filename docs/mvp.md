# MVP — Alcance de la primera versión

## 1. Objetivo

Construir una aplicación móvil de estudio útil y sencilla, basada en Pomodoro, asignaturas y compromisos académicos. Los diseños proporcionados se toman como referencia visual y funcional; los elementos que aumentan significativamente la complejidad se identifican como posteriores.

## 2. Incluido en el MVP

### 2.1. Pomodoro — página de inicio

- Temporizador de concentración con duración configurable.
- Descanso corto y largo configurables.
- Número de bloques antes del descanso largo configurable.
- Iniciar, pausar, reanudar, reiniciar y cancelar.
- Fase visible y progreso del ciclo.
- Asignatura y compromiso académico opcionalmente vinculados al bloque.
- Persistencia y recuperación del temporizador tras segundo plano o cierre.
- Inicio automático de descansos y de la siguiente concentración, ambos opcionales.
- Preferencias básicas de sonido para fin de periodo.
- Opción de evitar el bloqueo de pantalla durante una sesión, condicionada a capacidades de plataforma.

Valores por defecto: concentración 25 min, descanso corto 5 min, descanso largo 15 min, 4 bloques antes del descanso largo. Auto-inicio desactivado.

### 2.2. Asignaturas

- Crear, editar, archivar y consultar asignaturas.
- Nombre obligatorio, código opcional, periodo/semestre opcional, icono temático y color.
- Listado con búsqueda y filtros: todas, con compromisos, archivadas.
- Detalle de asignatura con tiempo acumulado, bloques completados, últimos registros, compromisos y acceso a iniciar un Pomodoro.
- Conservar las relaciones históricas al archivar.

### 2.3. Pendientes y compromisos

El MVP admite tipos de compromiso: examen, entrega/proyecto y actividad académica sencilla (por ejemplo, taller o quiz), como reflejan los diseños.

- Título, asignatura, fecha límite y tipo obligatorios.
- Descripción/notas opcionales.
- Hora opcional para compromisos de fecha sin hora.
- Estado pendiente/completado.
- Búsqueda, filtros por tipo y listado ordenado por fecha.
- Crear y editar mediante formulario/modal.
- Mostrar en una tarjeta el tiempo restante y, cuando haya datos, el progreso de bloques vinculados.
- Asociar un objetivo de Pomodoros al compromiso como dato opcional. El progreso se calcula a partir de sesiones vinculadas, no de un contador manipulable aislado.

No incluir en el MVP ponderación de nota, prioridad inteligente, ubicación/aula, colaborador, estimación de preparación ni notificaciones de prioridad.

### 2.4. Calendario

- Vista mensual.
- Navegación entre meses y acceso a «Hoy».
- Selección de día.
- Indicadores visuales para exámenes, entregas y otros compromisos.
- Lista de compromisos del día seleccionado.
- Acceso para crear un compromiso desde una fecha del calendario.

### 2.5. Estadísticas básicas

- Selector de periodo: semana, mes y global.
- Tiempo total de concentración.
- Número de bloques de concentración completados.
- Promedio diario en el periodo.
- Gráfico sencillo de concentración diaria.
- Distribución del tiempo por asignatura, incluyendo «Sin asignatura».
- Métricas derivadas exclusivamente de sesiones persistidas.

No incluir inicialmente eficiencia, correlaciones de productividad, zona de oro/horarios óptimos, predicciones ni analítica avanzada. Las metas diarias/semanales y rachas pueden entrar en una iteración posterior, aunque se muestran en diseños.

### 2.6. Ajustes y perfil — base

- Ajustes de duración Pomodoro y comportamiento automático.
- Tema claro/oscuro/sistema.
- Formato horario de 12/24 h y comienzo de semana.
- Perfil local editable con nombre y datos académicos opcionales.
- Información de privacidad local.

No incluir inicialmente importación/exportación de backup, cierre de curso guiado, clasificación de asignaturas por aprobada/repetir/inactiva, evaluación académica, ni sistemas completos de sonidos/notificaciones personalizados.

## 3. Secciones principales

La barra inferior se compone de Pomodoro, Estudios, Calendario y Estadísticas. Perfil y Ajustes son destinos secundarios desde la cabecera.

## 4. Fuera del MVP

- Cierre de curso con clasificación y creación automática del siguiente ciclo.
- Copia de seguridad JSON y restauración.
- Metas y rachas con sistema completo de hábitos.
- Notificaciones por asignatura desatendida o recordatorios programados.
- Prioridad crítica y alertas avanzadas de compromisos.
- Ponderación de nota y resultados de evaluación.
- Métricas de eficiencia, zona de oro y análisis de productividad por franja.
- Sonidos seleccionables extensos, cuenco tibetano u otras opciones específicas si requieren recursos adicionales.
- Funciones de nube, cuenta, sincronización o colaboración.

## 5. Criterios de aceptación

- La app abre en la pantalla Pomodoro.
- El temporizador permite configurar, iniciar, pausar, reanudar y cancelar.
- El estado temporal se recupera correctamente y una sesión completada se guarda una sola vez.
- Las asignaturas y compromisos se crean, editan y archivan/completan según su tipo.
- El calendario presenta los compromisos por fecha.
- Las estadísticas concuerdan con sesiones de concentración completadas.
- Los datos persisten localmente y la app funciona offline.
- La navegación corresponde a las cuatro secciones indicadas.
