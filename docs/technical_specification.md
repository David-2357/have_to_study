# Especificación técnica, modelo de datos y calidad

## 1. Arquitectura

Stack:
- Flutter/Dart estables actuales.
- Riverpod para estado y composición de dependencias.
- Drift/SQLite para persistencia local.
- GoRouter opcional para navegación declarativa.

Separación recomendada:
- `presentation`: widgets, pantallas, controladores/providers de UI.
- `application`: casos de uso y coordinación.
- `domain`: entidades, reglas y lógica del Pomodoro.
- `data`: Drift, DAOs, repositorios e implementaciones.

Los widgets no acceden directamente a tablas ni implementan reglas de negocio.

## 2. Modelo de datos propuesto

### `subjects`
- `id` INTEGER PK.
- `name` TEXT obligatorio.
- `code` TEXT nullable.
- `period` TEXT nullable (semestre/ciclo).
- `icon_key` TEXT.
- `color` TEXT.
- `status` TEXT: `active`, `archived`, y posibles estados ampliados futuros documentados.
- `created_at`, `updated_at` instante.

### `focus_sessions`
- `id` INTEGER PK.
- `subject_id` INTEGER nullable FK.
- `academic_event_id` INTEGER nullable FK.
- `started_at` instante UTC.
- `completed_at` instante UTC.
- `duration_seconds` INTEGER efectivo.
- `status` TEXT, MVP `completed`.
- `created_at` instante.

### `academic_events`
- `id` INTEGER PK.
- `subject_id` INTEGER FK obligatorio.
- `title` TEXT obligatorio.
- `type` TEXT: `exam`, `assignment`, `academic_activity`.
- `description` TEXT nullable.
- `due_at` instante o fecha local normalizada según decisión de implementación.
- `has_due_time` BOOLEAN.
- `target_pomodoros` INTEGER nullable.
- `status` TEXT: `pending`, `completed`.
- `created_at`, `updated_at` instante.

### `pomodoro_settings`
Fila singleton `id = 1`:
- `focus_minutes` INTEGER.
- `short_break_minutes` INTEGER.
- `long_break_minutes` INTEGER.
- `cycles_before_long_break` INTEGER.
- `auto_start_breaks` BOOLEAN.
- `auto_start_focus` BOOLEAN.
- `prevent_screen_lock` BOOLEAN (solo si se incluye en MVP).
- `completion_sound` TEXT (valor básico si se incluye).
- `updated_at` instante.

### `pomodoro_state`
Fila singleton `id = 1`:
- `phase` TEXT: `idle`, `focus`, `short_break`, `long_break`.
- `status` TEXT: `idle`, `running`, `paused`.
- `subject_id` INTEGER nullable FK.
- `academic_event_id` INTEGER nullable FK.
- `remaining_seconds` INTEGER.
- `phase_duration_seconds` INTEGER.
- `phase_started_at` instante nullable.
- `last_resumed_at` instante nullable.
- `completed_focus_cycles` INTEGER.
- `updated_at` instante.

### `student_profile`
Fila singleton:
- `id` INTEGER fijo.
- `display_name` TEXT nullable.
- `degree_name` TEXT nullable.
- `academic_period` TEXT nullable.
- `avatar_path` TEXT nullable (ruta local; validar existencia y permisos).
- `updated_at` instante.

### Preferencias de sistema
Se pueden guardar en una tabla singleton `app_preferences` o en almacenamiento de preferencias de Flutter, pero debe existir una única fuente para:
- Tema: `light`, `dark`, `system`.
- Formato horario: `12h`, `24h`.
- Inicio de semana.
- Preferencias UI equivalentes.

No persistir estadísticas agregadas duplicadas en MVP: derivarlas de sesiones. Metas y rachas futuras podrán añadir tablas después.

## 3. Relaciones y borrado

- `focus_sessions.subject_id` → `subjects.id`, `ON DELETE RESTRICT`.
- `academic_events.subject_id` → `subjects.id`, `ON DELETE RESTRICT`.
- `focus_sessions.academic_event_id` → `academic_events.id`, política restrictiva o `SET NULL` documentada.
- `pomodoro_state` referencia a sujeto/compromiso solo durante fase de concentración; limpiar referencias al archivar/eliminar según política.
- Preferir archivado lógico de asignaturas.
- Habilitar foreign keys en SQLite.
- Las operaciones de finalización de sesión deben ser transaccionales e idempotentes.

## 4. Tiempo y zonas horarias

- Persistir instantes inequívocos en UTC usando una unidad uniforme (epoch milisegundos recomendado).
- Presentar fechas y horas en zona horaria local.
- Los compromisos que no incluyan hora deben preservar semántica de fecha local; no convertirlos como si fueran un instante arbitrario sin especificar.
- Los intervalos de estadísticas se calculan a partir de límites locales convertidos a UTC.
- Considerar días de 23/25 horas por cambios de horario.
- Centralizar lógica temporal en servicios testeables.

## 5. Índices recomendados

- `focus_sessions(completed_at)`.
- `focus_sessions(subject_id, completed_at)`.
- `focus_sessions(academic_event_id, completed_at)`.
- `academic_events(status, due_at)`.
- `academic_events(subject_id, due_at)`.
- `subjects(status)`.

## 6. Consultas de estadísticas

- Tiempo total: `SUM(duration_seconds)` de sesiones completadas en el rango.
- Bloques completados: `COUNT(*)` de sesiones completadas.
- Por asignatura: agrupar por `subject_id`; incluir null como «Sin asignatura».
- Diario: agrupar por fecha local a partir del rango de consulta.
- Promedio diario: dividir por días definidos del periodo, especificando si días sin sesiones cuentan como cero (recomendación: sí, para el promedio del periodo calendario).

## 7. Drift y organización sugerida

```text
lib/
  app/
  core/
    time/
    theme/
  features/
    pomodoro/
      domain/
      application/
      data/
      presentation/
    subjects/
      domain/
      application/
      data/
      presentation/
    academic_events/
      domain/
      application/
      data/
      presentation/
    calendar/
      application/
      presentation/
    statistics/
      application/
      presentation/
    profile/
    settings/
  data/
    database/
      app_database.dart
      tables/
      daos/
```

Esta estructura es orientativa; evitar crear capas ceremoniales si el MVP no lo necesita. Mantener lógica de dominio desacoplada y testeable.

## 8. Migraciones

- Definir `schemaVersion` en Drift.
- Migraciones explícitas por versión.
- Inicializar filas singleton de forma idempotente.
- No borrar/recrear la base de datos para actualizar.
- Testear migraciones desde cada versión soportada.
- Conservar historial al cambiar estados de asignaturas.

## 9. Testing y calidad

### Unit tests
- Máquina de estados del Pomodoro.
- Selección de descanso corto/largo.
- Pausa, reanudación, cancelación y reset.
- Recuperación de fases vencidas.
- Cálculo de duración efectiva.
- Reglas de asignaturas y compromisos.
- Cálculo de estadísticas y límites de fechas.

### Database tests
- Relaciones y claves foráneas.
- Transacciones de finalización.
- Idempotencia contra duplicados.
- Consultas por asignatura, fecha y estado.
- Migraciones.

### Widget/integration tests
- Flujo inicio/pausa/reanudar Pomodoro.
- Crear asignatura.
- Crear compromiso.
- Navegar calendario y seleccionar fecha.
- Visualizar estadísticas vacías y con datos.
- Recuperación tras lifecycle de app simulado.

### Calidad
- Lints de Dart/Flutter.
- Validación en Android e iOS.
- Accesibilidad: contraste, escalado de texto y semantic labels.
- Evitar reconstrucciones globales cada segundo; limitar el refresco del timer a widgets necesarios.
- No usar datos de muestra como si fueran métricas reales en producción.

## 10. Seguridad y privacidad

- Datos académicos almacenados localmente.
- No incluir secretos en el cliente.
- Validar rutas locales de avatar y ficheros importados.
- Exportación/importación (futura) debe validar esquema, tamaño, contenido y versión; no ejecutar contenido del JSON.
- Borrado de datos (futuro) requiere confirmación clara y operación transaccional.
- No solicitar permisos de notificaciones o archivos antes de que una función incluida los necesite.

## 11. Riesgos y decisiones a cerrar

- Comportamiento exacto si el dispositivo permanece apagado más allá de varias fases Pomodoro.
- Definición de «pasar al descanso» manualmente durante una concentración y su impacto en registro.
- Política de nombres/códigos duplicados de asignaturas.
- Semántica de compromisos sin hora al almacenar en SQLite.
- Si la meta diaria, racha y tiempo acumulado del dashboard entran en un release posterior o se adelantan.
- Paquete y comportamiento de prevención de bloqueo de pantalla compatible con Android/iOS.
