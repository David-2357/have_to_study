# Producto — Have to Study

## 1. Visión

Have to Study es una aplicación móvil de organización académica y concentración. Su experiencia se centra en un temporizador Pomodoro asociado a asignaturas y compromisos académicos. Incluye calendario, seguimiento de objetivos y estadísticas para ayudar al estudiante a comprender y organizar su dedicación.

La aplicación prioriza la privacidad local: el usuario puede gestionar su información académica sin cuenta ni servidor remoto.

## 2. Objetivos

- Reducir la fricción para iniciar una sesión de estudio.
- Permitir estructurar la concentración mediante ciclos Pomodoro.
- Organizar asignaturas, exámenes, entregas y otros compromisos académicos.
- Relacionar el tiempo registrado con materias y objetivos.
- Ofrecer una visión diaria, semanal, mensual e histórica del estudio.
- Mantener los datos en el dispositivo y permitir copias de seguridad locales.

## 3. Usuarios y contexto

Estudiantes que gestionan varias asignaturas, evaluaciones y entregas, y desean mantener hábitos de concentración medibles.

## 4. Principios del producto

- **Enfoque:** el temporizador es el punto de entrada y la función central.
- **Contexto académico:** las sesiones, materias y compromisos se relacionan.
- **Datos explicables:** las métricas se derivan de registros identificables.
- **Privacidad soberana:** los datos se guardan localmente por defecto.
- **Personalización acotada:** configuraciones útiles sin sobrecargar el flujo principal.
- **Progresión:** funcionalidades de planificación y análisis avanzado se desarrollan después de validar el núcleo.

## 5. Navegación prevista según los diseños

La navegación inferior contiene cuatro secciones:
1. Pomodoro.
2. Estudios (asignaturas y pendientes).
3. Calendario.
4. Estadísticas.

El perfil del estudiante y los ajustes se abren desde acciones en la cabecera. Calendario, compromisos, perfil y ajustes están representados en los diseños entregados; por tanto, forman parte de la experiencia objetivo. El documento `mvp.md` delimita cuáles se implementan en la primera entrega.

## 6. Plataforma y stack

- Android e iOS con Flutter y Dart estables actuales.
- Riverpod para estado y dependencias.
- Drift sobre SQLite para persistencia.
- GoRouter para navegación si la estructura de rutas lo requiere.
- Diseño offline-first, sin cuenta ni backend en el alcance local inicial.

## 7. Fuera del alcance de una primera entrega local

- Autenticación y sincronización en la nube.
- Colaboración entre estudiantes.
- Integraciones con LMS o calendarios externos.
- Recomendaciones generadas por IA.
- Planificación automática integral.
- Analítica remota o telemetría académica.

## 8. Documentación

- `mvp.md`: alcance de la primera versión.
- `functional_requirements.md`: funcionalidades y reglas de negocio.
- `ui_ux.md`: requisitos de interfaz derivados de los diseños.
- `technical_specification.md`: arquitectura, persistencia, calidad y pruebas.
