# Chart Widgets — Data Visualization System

Reusable chart widgets for displaying aggregate survey data. Built on [fl_chart](https://pub.dev/packages/fl_chart) v0.68.0 with AppTheme integration.

## Location

```
frontend/lib/src/core/widgets/data_display/
├── app_bar_chart.dart     # Bar chart (counts, histograms)
├── app_pie_chart.dart     # Pie chart (yes/no, distributions)
├── app_stat_card.dart     # Stat card (single metric display)
├── data_display.dart      # Barrel file (exports all)
```

Import via barrel:
```dart
import 'package:frontend/src/core/widgets/data_display/data_display.dart';
```

---

## AppBarChart

Wraps fl_chart's `BarChart` for displaying categorical data (option counts, histograms).

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `String` | **required** | Chart title displayed above bars |
| `data` | `Map<String, double>` | **required** | Label → value mapping |
| `barColor` | `Color` | `AppTheme.primary` | Color for all bars |
| `height` | `double` | `300` | Chart height in logical pixels |
| `showValues` | `bool` | `true` | Show value labels above bars |

### Usage

```dart
AppBarChart(
  title: 'Response Distribution',
  data: {'Red': 15, 'Blue': 22, 'Green': 8},
  barColor: AppTheme.info,
  height: 250,
)
```

### Behavior

- **Empty data**: Shows centered "No data available" message
- **Long labels**: Rotated 90° when > 8 characters, truncated at 12
- **Tooltips**: Touch/hover shows label + value
- **Grid**: Horizontal lines only, styled with `AppTheme.gray`
- **Rounded corners**: Top corners rounded (4px radius)

---

## AppPieChart

Wraps fl_chart's `PieChart` for displaying proportional data (yes/no, single-choice distributions).

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `String` | **required** | Chart title displayed above pie |
| `data` | `Map<String, double>` | **required** | Label → value mapping |
| `colors` | `List<Color>?` | `defaultColors` | Segment colors (cycles if data > colors) |
| `height` | `double` | `250` | Chart height in logical pixels |
| `showLegend` | `bool` | `true` | Show legend beside chart |

### Default Colors

```dart
static const List<Color> defaultColors = [
  AppTheme.primary,     // #22446D
  AppTheme.secondary,   // #145B2C
  AppTheme.info,        // #0057B8
  AppTheme.caution,     // #FF9900
  AppTheme.error,       // #A6192E
  AppTheme.success,     // #04B34F
  Color(0xFF8E44AD),    // Purple
  Color(0xFF2C3E50),    // Dark gray
];
```

### Usage

```dart
AppPieChart(
  title: 'Yes/No Distribution',
  data: {'Yes': 75, 'No': 25},
  colors: [AppTheme.success, AppTheme.error],
  showLegend: true,
)
```

### Behavior

- **Empty data**: Shows centered "No data available" message
- **Touch interaction**: Touched segment expands slightly (radius 55 → 65)
- **Percentages**: Shown inside each segment and in legend
- **Legend**: Right side, color swatch + label + percentage
- **Donut style**: 40px center space radius
- **Color cycling**: If more categories than colors, wraps around

---

## AppStatCard

Simple card for displaying a single metric with icon, label, and large value.

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | **required** | Descriptive label (e.g. "Respondents") |
| `value` | `String` | **required** | Large display value (e.g. "42", "80%") |
| `icon` | `IconData?` | `null` | Optional icon displayed left |
| `color` | `Color` | `AppTheme.primary` | Accent color for icon bg and top border |
| `subtitle` | `String?` | `null` | Optional text below value |

### Usage

```dart
AppStatCard(
  label: 'Respondents',
  value: '42',
  icon: Icons.people,
  color: AppTheme.info,
  subtitle: 'out of 50 assigned',
)
```

### Styling

- **Top border**: 3px colored accent line
- **Shadow**: Subtle elevation (0x0D000000, blur 8)
- **Icon**: 44x44 container with 10% opacity background
- **Min height**: 120px (grid-friendly)
- **Typography**: Label in `captions`/muted, value in `heading4`/bold

---

## Usage in Research Data Page

The research data page maps each response type to the appropriate chart:

| Response Type | Widget | Data Format |
|---------------|--------|-------------|
| `yesno` | `AppPieChart` | `{"Yes": count, "No": count}` |
| `single_choice` | `AppBarChart` | `{"Option A": count, "Option B": count, ...}` |
| `multi_choice` | `AppBarChart` | `{"Option A": count, "Option B": count, ...}` |
| `number` | `AppBarChart` | `{"0-10": count, "11-20": count, ...}` (histogram) |
| `scale` | `AppBarChart` | `{"1": count, "2": count, ... "10": count}` |
| `openended` | _Text only_ | `"X responses"` (no chart) |

Overview stat cards:
```dart
Row(children: [
  AppStatCard(label: 'Respondents', value: '$count', icon: Icons.people),
  AppStatCard(label: 'Completion Rate', value: '$rate%', icon: Icons.check_circle),
  AppStatCard(label: 'Questions', value: '$count', icon: Icons.quiz),
])
```

---

## Adding a New Chart Widget

1. Create `app_<type>_chart.dart` in `data_display/`
2. Follow the `StatelessWidget` pattern (or `StatefulWidget` if interactive)
3. Accept `title`, `data`, `height`, and widget-specific props
4. Use `AppTheme` colors and text styles throughout
5. Handle empty data with centered message
6. Export from `data_display.dart` barrel file
7. Add widget tests in `frontend/test/core/widgets/data_display/`

---

## Dependencies

- `fl_chart: ^0.68.0` — charting library
- `AppTheme` — color palette and typography
- No external state management needed (charts are pure presentation)
