<div align="center">

# SURGERY OPTIMIZER

**A Flutter application for planning and optimizing monthly surgical schedules across hospital operating rooms.**

*Developed as a project for the **Decision Support System and Analytics** course.*

</div>


## Overview

Surgery Optimizer is a cross-platform Flutter application designed to assist hospital staff in managing and scheduling surgical interventions across multiple operating rooms. It provides a structured workflow: first, interventions are entered for each department and month; then a smart scheduling algorithm automatically distributes them across the available operating rooms, respecting a set of clinical and operational constraints.

The application currently targets **web** (Flutter Web), with the architecture ready for mobile and desktop deployment as well.



## Features

- **Department-based intervention management** — 7 surgical departments, each with its own color and icon, independently managing their list of planned interventions.
- **Month/year scoping** — each month stores a completely separate set of interventions; switching period instantly reloads the relevant data.
- **Persistent storage** — all interventions and generated schedules are saved locally via `shared_preferences` and survive navigation and app restarts.
- **Automatic schedule generation** — a greedy two-phase algorithm distributes interventions across 5 operating rooms, optimizing utilization while satisfying hard constraints.
- **Interactive monthly calendar** — one calendar grid per operating room, showing each intervention as a color-coded chip with name and time range. Tapping a chip opens a detailed popup.



## Application Structure

```
lib/
├── main.dart                              # App entry point, routing
├── models/
│   ├── intervention.dart                  # Intervention data model
│   └── scheduled_block.dart               # Scheduled surgery block model
├── pages/
│   ├── home_page.dart                     # Home  /landing page
│   ├── intervention_insertion_page.dart   # Intervention management page
│   ├── monthly_scheduling_page.dart       # Monthly calendar view
│   └── not_found_page.dart                # 404 fallback page
└── services/
    └── scheduler.dart                     # Scheduling algorithm
```



## Pages

### Home Page (`/`)

The landing page with two main navigation options:

- **Inserimento Interventi** — opens the intervention management page.
- **Programmazione Mensile** — opens the monthly schedule calendar.

### Intervention Insertion Page (`/interventions`)

Where hospital staff enter planned surgical interventions for a given month.

**Period selector** — a dropdown at the top lets you select month and year. Data is completely isolated per period: selecting a different month loads (or starts fresh with) that month's interventions.

**Department cards** — one card per department, showing:
- Department name with its icon.
- A badge showing the number of planned interventions for the selected month.
- A badge showing the average intervention duration.
- The list of added interventions, each displaying name, duration, and compatible operating rooms.
- A delete button for each intervention.
- An "Aggiungi intervento" button to open the insertion dialog.

**Add intervention dialog** — a modal with:
- Name of the intervention (max 80 characters).
- Duration selector (hours: 0–14, minutes: 0, 5, 10, … 55).
- Compatible operating room selector (multi-select chips for Sala 1–5).
- Inline validation: name required, duration ≥ 5 minutes, at least one room selected.

**"Genera Programmazione" button** — at the bottom of the page. Runs the scheduling algorithm on all interventions of the selected month, saves the resulting schedule, shows a summary snackbar, and navigates directly to the monthly calendar for that month.

### Monthly Scheduling Page (`/scheduling`)

Displays the generated schedule for a selected month.

**Period selector** — same month/year dropdown as the intervention page; switching period reloads the saved schedule for that month.

**Room calendar cards** — one card per operating room (Sala 1–5), each containing a full monthly calendar grid with:
- Day-of-week headers (Mon–Sun).
- Each day cell showing the day number and all interventions scheduled in that room on that day.
- Interventions rendered as color-coded chips (color = department color) with the intervention name and time range (e.g. `8:00-9:30`).
- Weekend days visually dimmed.

**Intervention detail popup** — tapping any intervention chip opens an `AlertDialog` with:
- A colored header (department color) showing the department icon, intervention name, and department name.
- Detail rows: operating room, date, time range, duration.
- A "Chiudi" button in the department color.

## Scheduling Algorithm

The algorithm is implemented in [lib/services/scheduler.dart](lib/services/scheduler.dart) and uses a **greedy two-phase heuristic** inspired by the bin-packing problem.

### Operating constraints

| Parameter | Value |
|-----------|-------|
| Operating hours | 08:00 – 22:00 (840 min/day) |
| Operating rooms | 5 (Sala 1–5) |
| Min interventions per department per week | 1 |
| Department time overlap across rooms | Not allowed |
| Same-department interventions in same room/day | Must be consecutive (no other dept in between) |

### Phase 1 — Weekly constraint satisfaction

The month is divided into 7-day windows. For each week and each active department (one with at least one planned intervention), the algorithm checks whether that department already has a scheduled block in that week. If not, it forces the placement of one of its interventions (the longest unscheduled one), ensuring the minimum weekly coverage constraint is met before optimizing utilization.

### Phase 2 — Best-Fit Decreasing (BFD)

Remaining interventions are sorted by duration in descending order (longest first, as they are hardest to place) and scheduled greedily using a **best-fit** strategy. For each intervention, every valid `(room, day)` combination is scored and the highest-scoring slot is chosen.

**Scoring function:**

```
score = -afterFree + (deptAlreadyOnDay ? 100 : 0)
```

- `-afterFree`: primary objective — minimizes residual free time in the room that day, maximizing utilization (classic best-fit).
- `+100 if the department already has a block on that day`: secondary objective — concentrates each department's interventions on fewer days, reducing the number of distinct operating days per department (fewer team changeovers).

### Validity checks (per candidate slot)

A `(room, day)` slot is considered only if all of the following hold:

1. The intervention fits within the 22:00 cutoff (start of last block + duration ≤ 1320 min).
2. The room is in the intervention's list of compatible rooms.
3. No other block of the **same department** in any **other room** on the same day overlaps with the proposed time window (`s1 < e2 && s2 < e1`).
4. **Consecutiveness**: if the department already has at least one intervention in this room on this day, the last slot currently occupying the room must belong to the same department. This guarantees that all interventions of a given department in a given room on a given day form an uninterrupted block — no other department can be inserted in between.

Interventions are placed back-to-back within each room (no idle gaps between consecutive blocks).



## Data Persistence

All data is stored locally using the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package. On Flutter Web this maps to `localStorage`.

| Data | Storage key format |
|------|--------------------|
| Interventions (per dept, per period) | `dept_interventions_{year}_{month}_{deptId}` |
| Generated schedule (per period) | `schedule_{year}_{month}` |

> **Note for Flutter Web development**: each `flutter run` session may use a different random port, which means `localStorage` is scoped to that port and previously saved data will not be visible. To keep data persistent across restarts during development, always run with a fixed port:
> ```
> flutter run -d chrome --web-port 8080
> ```



## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [`flutter`](https://flutter.dev) | SDK | UI framework |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | ^6.2.1 | Inter typeface |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | ^2.5.5 | Local data persistence |
| [`font_awesome_flutter`](https://pub.dev/packages/font_awesome_flutter) | ^10.7.0 | Extended icon set |
| [`url_launcher`](https://pub.dev/packages/url_launcher) | ^6.2.5 | External URL handling |



## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.9.2
- Dart SDK ≥ 3.9.2
- A supported browser (Chrome recommended for Flutter Web)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd surgery_optimizer

# Install dependencies
flutter pub get
```

### Running the app

```bash
# Run on Chrome (development) with a fixed port to preserve localStorage data
flutter run -d chrome --web-port 8080

# Build for web production
flutter build web
```



## How to Use

### 1. Enter interventions

1. Navigate to **Inserimento Interventi** from the home page.
2. Select the target **month and year** from the period selector at the top.
3. For each surgical department, tap **Aggiungi intervento**.
4. Fill in the intervention name, duration, and the operating rooms it is compatible with.
5. Tap **Aggiungi intervento** in the dialog to confirm. The intervention appears in the department card and is saved immediately.
6. Repeat for all departments and interventions needed for the month.

### 2. Generate the schedule

1. Once interventions are entered, tap **Genera Programmazione** at the bottom of the page.
2. The algorithm runs instantly and saves the resulting schedule.
3. A snackbar confirms how many interventions were successfully scheduled out of the total.
4. The app automatically navigates to the monthly calendar for the selected period.

### 3. View the schedule

1. The **Programmazione Mensile** page shows one calendar card per operating room.
2. Each card contains a full monthly grid with color-coded intervention chips.
3. Tap any chip to open the detail popup showing room, date, time range, and duration.
4. Use the period selector to browse schedules for other months.



## Project Status

This project is currently in active development. The core workflow (intervention entry → automatic scheduling → calendar visualization) is fully functional. Planned future improvements may include export to PDF/Excel, manual schedule editing, and multi-user support.

## Authors
<a href="https://github.com/AntonioSouls">
  <img src="https://github.com/AntonioSouls.png" width="80">
</a>
