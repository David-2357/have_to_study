# Requisitos funcionales y reglas de negocio

## 1. Pomodoro y sesiones

### Estados

El temporizador se modela mediante estados explícitos, evitando combinaciones inválidas:
- `idle`: sin fase activa.
- `running`: periodo en marcha.
- `paused`: periodo pausado.

Fases:
- `focus`
- `short_break`
- `long_break`

### Reglas

- Una sesión de estudio corresponde a una fase `focus` completada.
- Solo la concentración completada genera un registro de sesión.
- Los descansos y el tiempo pausado no se contabilizan como estudio.
- El ciclo elige descanso largo tras alcanzar el número de bloques configurado; después el contador se reinicia.
- La asignatura y el compromiso opcional se fijan al comenzar la concentración. Cambiar selectores no altera la sesión actual.
- Cancelar o reiniciar una concentración no registra un bloque completado; pedir confirmación si hay progreso.
- La finalización y persistencia deben ser idempotentes, evitando duplicados durante la recuperación.
- Configuración cambiada durante una fase se aplica a fases posteriores, no altera silenciosamente la fase en curso.
- El cálculo temporal se basa en timestamps persistidos y tiempo pausado acumulado, no en que un timer de UI permanezca vivo.
- Auto-inicio de descanso y auto-inicio de concentración son preferencias independientes.
- La app procesa de forma determinista fases que hayan vencido mientras estuvo cerrada. El comportamiento al pasar el dispositivo apagado por varias fases debe definirse y probarse explícitamente.

### Configuración inicial y validaciones

- Concentración: 25 min (rango recomendado 1–180).
- Descanso corto: 5 min (1–60).
- Descanso largo: 15 min (1–90).
- Bloques antes de descanso largo: 4 (1–12).
- Auto-inicios: desactivados.
- Duraciones y ciclo deben validarse tanto en UI como en dominio.

## 2. Asignaturas

Campos funcionales:
- Nombre obligatorio.
- Código académico opcional.
- Periodo/semestre opcional.
- Color e icono temático.
- Estado activa/archivada.
- Timestamps de creación y actualización.

Reglas:
- Normalizar espacios del nombre y rechazar vacío.
- Evitar duplicados de nombre/código entre asignaturas activas si se define una política de unicidad.
- Archivar, no borrar físicamente, cuando exista historial o compromisos.
- Asignaturas archivadas conservan sesiones y compromisos y aparecen en históricos.
- Las archivadas se excluyen por defecto del selector de nuevas sesiones.

## 3. Compromisos académicos

Tipos admitidos en el modelo base: `exam`, `assignment`, `academic_activity` (para taller/quiz u otros tipos básicos).

Campos:
- Título obligatorio.
- Tipo obligatorio.
- Asignatura obligatoria.
- Fecha límite obligatoria; hora opcional.
- Descripción/notas opcionales.
- Estado `pending` o `completed`.
- Objetivo de Pomodoros opcional.
- Timestamps.

Reglas:
- Se permiten fechas pasadas para registro retrospectivo.
- Pendientes ordenados por fecha ascendente.
- Marcar completado no elimina; se puede reabrir si se marcó por error.
- Objetivo Pomodoro, cuando exista, debe ser positivo.
- El progreso se deriva de sesiones asociadas que estén completadas.
- Archivado de asignatura no elimina compromisos.
- No enviar notificaciones en el MVP.
- Campos de ponderación, prioridad, aula, colaborador y preparación son fuera del MVP.

## 4. Calendario

- La vista mensual refleja fechas de compromisos.
- Cada compromiso se muestra en el día local de su fecha límite.
- Los indicadores deben diferenciar tipos con color y/o icono y etiqueta accesible.
- Seleccionar una fecha filtra la lista inferior.
- «Hoy» vuelve a la fecha actual del dispositivo.
- Crear desde una fecha del calendario preselecciona dicha fecha en el formulario.

## 5. Estadísticas

Fuente de verdad: sesiones de concentración completadas persistidas.

Incluir:
- Tiempo total.
- Bloques completados.
- Promedio diario.
- Resumen por día para el periodo seleccionado.
- Distribución por asignatura y categoría «Sin asignatura».

Excluir:
- Descansos.
- Pausas.
- Sesiones canceladas/incompletas.
- Duplicados de finalización.

Reglas temporales:
- Día y semana se agrupan en la zona horaria local del dispositivo.
- El comienzo de semana debe respetar preferencia del usuario (lunes por defecto).
- El cálculo se hace con precisión de segundos; redondeo solo en presentación.
- Semana, mes y global deben usar intervalos definidos sin solapamiento.

## 6. Perfil local

El perfil puede incluir:
- Nombre visible.
- Avatar iniciales o imagen local opcional.
- Carrera/titulación y semestre/ciclo académico opcionales.

Estos datos son de presentación y contexto; no deben ser necesarios para usar el temporizador. No se exige crear una cuenta ni autenticar al usuario.

## 7. Ajustes

Preferencias previstas en diseños:
- Meta diaria de estudio.
- Duraciones Pomodoro y ciclos.
- Auto-inicio de descansos y siguiente Pomodoro.
- Evitar bloqueo de pantalla durante concentración.
- Sonido de finalización.
- Aviso de asignatura desatendida y umbral en días.
- Recordatorios locales.
- Exportar/importar respaldo JSON.
- Borrar datos locales.
- Tema claro/oscuro/automático.
- Inicio de semana.
- Formato 12/24 horas.

Para el MVP se implementa configuración Pomodoro y preferencias visuales/horarias básicas. Meta diaria, notificaciones, backup y borrado total se postergan. Si el borrado total se incorpora, debe requerir confirmación reforzada.

## 8. Cierre de curso

Los diseños muestran un flujo de cierre que clasifica asignaturas como aprobadas, repetir o inactivas, con organización del siguiente ciclo. Es una funcionalidad de versión futura:
- No se implementa cierre guiado en MVP.
- No se altera el historial.
- Las categorías futuras deben mapearse a archivado/continuidad sin borrar registros.
- El diseño detallado de creación del siguiente curso queda pendiente de una especificación futura.

## 9. Privacidad y comportamiento local

- No enviar información académica a servidores en el alcance offline-first.
- No exigir cuenta ni conexión para las operaciones centrales.
- Los datos de perfil y estadísticas permanecen en el dispositivo.
- El acceso a archivos para respaldo solo se solicitará cuando se use la función correspondiente.
- Borrar datos locales debe eliminar también sesiones, asignaturas, compromisos, perfil y preferencias, con confirmación explícita.
