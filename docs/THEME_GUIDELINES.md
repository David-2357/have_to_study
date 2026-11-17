# Semantic Theme Guidelines

This document establishes the semantic color usage standards for Have to Study. UI components must exclusively reference these semantic variables to ensure visual consistency, correct contrast, and reactivity between Light and Dark themes.

---

## Architecture Overview

The application uses a hybrid theme architecture:
1. **`AppColorTheme` (via `ThemeExtension<AppColorTheme>`)**: Dynamic, theme-reactive semantic colors accessible on any widget via `context.colors.<property>`.
2. **`AppColors`**: Static brand identity tokens, fixed category hues, and academic event type colors.
3. **Adaptive Subject Colors (`SubjectModel.displayColor(bool isDark)`)**: Luminance-adjusted subject tokens providing high contrast in dark mode.

---

## Semantic Color Tokens

### 1. Dynamic Surface & Content Tokens (`context.colors`)

| Property | Light Theme Role | Dark Theme Role | Semantic Usage |
|---|---|---|---|
| `colors.background` | Light slate blue-gray (`#F4F7FC`) | Deep navy slate (`#0F172A`) | Scaffold background, route canvas, full-screen backdrops. |
| `colors.surface` | Pure white (`#FFFFFF`) | Elevated dark slate (`#1E293B`) | Cards, dialogs, bottom sheets, elevated containers, navigation bars. |
| `colors.surfaceVariant` | Soft cool gray (`#EDF2F7`) | Muted slate (`#334155`) | Nested containers, segmented control tracks, stepper backgrounds, search input fills, chip backgrounds. |
| `colors.textPrimary` | Deep charcoal (`#1E2638`) | Crisp off-white (`#F8FAFC`) | High-emphasis typography: headings, screen titles, primary values, active tab labels. |
| `colors.textSecondary` | Medium slate gray (`#6B7280`) | Soft steel gray (`#94A3B8`) | Medium-emphasis typography: subtitles, metadata, secondary descriptions, inactive control labels. |
| `colors.textMuted` | Light slate gray (`#9CA3AF`) | Dim slate (`#64748B`) | Low-emphasis typography: placeholder hints, trailing timestamps, unselected icon states. |
| `colors.border` | Subtle gray outline (`#E2E8F0`) | Slate boundary (`#334155`) | Card borders, dividers, text field outlines, container frames. |
| `colors.isDark` | `false` | `true` | Boolean flag for conditional contrast and opacity adjustments. |

---

### 2. Brand & Category Tokens (`AppColors`)

| Constant | Semantic Role | Foreground Usage | Background / Container Usage |
|---|---|---|---|
| `AppColors.primary` | Core brand identity | Primary button labels, active tab icons, key highlight elements. | Elevated buttons, active toggle chips, FABs. |
| `AppColors.primaryDark` | Deep brand shade | Hover/pressed states for primary actions. | — |
| `AppColors.primaryLight` | Subtle brand tint | — | Selected badge/pill backgrounds in light mode; use with `alpha: 0.25` in dark mode. |
| `AppColors.success` | Positive state / Completion | Checkmarks, completed status text, on-schedule tags. | Success icons, completion pills. |
| `AppColors.successLight` | Subtle positive tint | — | Success badge background in light mode; use with `alpha: 0.22` in dark mode. |
| `AppColors.warning` | Alert / Imminent deadline | Warning icons, due-soon labels, overdue notices. | Alert pills, warning banners. |
| `AppColors.warningLight` | Subtle warning tint | — | Warning badge background in light mode; use with `alpha: 0.22` in dark mode. |
| `AppColors.info` | Information | Informational icons, tips, guidance text. | Info badges, informational callouts. |
| `AppColors.infoLight` | Subtle info tint | — | Info badge background in light mode; use with `alpha: 0.22` in dark mode. |
| `AppColors.purple` | Focus milestone | Milestone metrics, special achievements. | Milestone badges, purple category chips. |
| `AppColors.purpleLight` | Subtle purple tint | — | Metric icon backgrounds in light mode; use with `alpha: 0.22` in dark mode. |
| `AppColors.teal` | Local privacy & calm | Shield icons, local storage badges, zen mode. | Privacy banners, calm metrics. |
| `AppColors.tealLight` | Subtle teal tint | — | Teal badge background in light mode; use with `alpha: 0.22` in dark mode. |

---

### 3. Academic Event Type Tokens (`AppColors`)

| Constant | Event Type | Foreground Color | Background / Tint Role |
|---|---|---|---|
| `AppColors.exam` | Exam / Evaluation | `AppColors.exam` | Light: `AppColors.examLight`; Dark: `AppColors.exam.withValues(alpha: 0.22)`. |
| `AppColors.assignment` | Assignment / Homework | `AppColors.assignment` | Light: `AppColors.assignmentLight`; Dark: `AppColors.assignment.withValues(alpha: 0.22)`. |
| `AppColors.activity` | Workshop / Activity | `AppColors.activity` | Light: `AppColors.activityLight`; Dark: `AppColors.activity.withValues(alpha: 0.22)`. |

---

## UI Component Color Reference

### 1. Screen & Scaffolding
- **Scaffold background:** `colors.background`
- **AppBar background:** `colors.background` (elevation `0`)
- **AppBar title & icons:** `colors.textPrimary`
- **System Navigation Bar:** `colors.surface` via `AnnotatedRegion<SystemUiOverlayStyle>`

### 2. Cards & Elevation Hierarchy
- **Level 1 Surface (Cards, list items, modal surfaces):**
  - Background: `colors.surface`
  - Border: `Border.all(color: colors.border)`
- **Level 2 Surface (Nested containers, stepper controls, segmented tracks):**
  - Background: `colors.surfaceVariant`
  - Border: none or `colors.border`

### 3. Navigation Bar (`BottomNavigationBar`)
- **Bar Container:** `colors.surface` with top border `colors.border`
- **Active Item (icon & text):** `AppColors.primary`
- **Inactive Item (icon & text):** `colors.textMuted`

### 4. Interactive Buttons & Controls
- **Filled / Primary Button (`ElevatedButton`):**
  - Background: `AppColors.primary`
  - Foreground / Text: `Colors.white`
- **Outlined Button (`OutlinedButton`):**
  - Border & Foreground: `AppColors.primary`
  - Background: `Colors.transparent`
- **Text Button (`TextButton`):**
  - Foreground: `AppColors.primary` or `colors.textSecondary`
- **Numeric Stepper / Counter Controls:**
  - Container background: `colors.surfaceVariant`
  - Increment/decrement icons: `colors.isDark ? Color(0xFF818CF8) : AppColors.primary`
  - Value text: `colors.textPrimary`

### 5. Form Fields & Inputs (`TextField`)
- **Fill / Container:** `colors.surfaceVariant` (or `colors.surface` on nested cards)
- **Border (enabled):** `OutlineInputBorder(borderSide: BorderSide(color: colors.border))`
- **Border (focused):** `OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary, width: 1.5))`
- **Text:** `colors.textPrimary`
- **Placeholder / Hint:** `colors.textMuted`
- **Prefix / Suffix Icons:** `colors.textMuted`

### 6. Badges, Tags & Status Indicators
- **Adaptive tint pattern:**
  - Light mode: use `<Color>Light` (e.g. `AppColors.warningLight`).
  - Dark mode: use `<Color>.withValues(alpha: 0.22)` over dark surface.
- **Label / Icon:** matching saturated token (e.g. `AppColors.warning` or adaptive counterpart).

### 7. Subject Identity Colors
- Always obtain via `subject.displayColor(colors.isDark)` rather than raw `subject.color`.
- Dark mode maps deep indigo, dark blue, and low-luminance tones to high-contrast pastel variants for legible borders, icons, and badges.

---

## Prohibited Practices

- **Never hardcode hex values** (`#FFFFFF`, `0xFF1E293B`, etc.) in widget build methods. Reference `colors.<property>` or `AppColors.<property>` exclusively.
- **Never use deprecated Flutter ColorScheme properties** (such as `background`, `onBackground`, `surfaceVariant` on ColorScheme).
- **Never read static mutable color states.** Always access theme extension via `context.colors`.
