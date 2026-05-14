<div align="center">

# SURGERY OPTIMIZER

**A Flutter application for Planning and Optimizing Monthly Surgical Schedules across hospital operating rooms.**

*Developed as a project for the **Decision Support System and Analytics** course.*

</div>


## Overview

**Surgery Optimizer** is a cross-platform Flutter application designed to assist hospital staff in managing and scheduling surgical interventions across multiple operating rooms.  
It provides a structured workflow: 
1. Interventions are entered for each department and month; 
2. Then a smart scheduling algorithm automatically distributes them across the available operating rooms, respecting a set of clinical and operational constraints;  

The application currently targets **web** (Flutter Web), with the architecture ready for mobile and desktop deployment as well.


## How it Works

When the application starts, it lands on the **Home Page**, which presents two main navigation options: 
1. **Intervention Insertion Page**, leading to the intervention management page;
2. **Monthly Scheduling Page**, leading to the monthly schedule calendar;

On the **Intervention Insertion Page**, hospital staff begin by selecting a target month and year from a dropdown at the top of the screen. Each period is completely isolated, so switching to a different month loads that month's own set of interventions without affecting any other. The page then shows one card per surgical department, each displaying its name, icon, the number of planned interventions for the selected period, and their average duration. From any department card, staff can tap **Add Intervention** to open a dialog where they fill in the intervention name (up to 80 characters), choose its duration via separate hour and minute selectors, and pick which operating rooms it is compatible with. The form validates inline — a name is required, the duration must be at least 5 minutes, and at least one room must be selected. Once all interventions for the month have been entered, tapping **Generate Scheduling** at the bottom of the page runs the `Scheduling Algorithm`, saves the result, and automatically navigates to the monthly calendar for that period.

The **Monthly Scheduling Page** presents the generated schedule through one calendar card per operating room (Room 1–5). Each card contains a full monthly grid where every day cell can hold one or more color-coded intervention chips — the color identifies the department, and each chip shows the intervention name alongside its time range (e.g. `8:00–9:30`). Weekend days are visually dimmed to make working days stand out at a glance. Tapping any chip opens a detail popup that summarises all the relevant information: department, operating room, date, time range, and total duration. The same period selector from the insertion page is available here too, allowing staff to browse the saved schedules for any past or future month.


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


## Application Structure

The project is structured as follows:

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

- **`main.dart`** — application entry point; defines the routing table and maps URL paths to the corresponding pages.
- **`models/intervention.dart`** — data model representing a single planned surgical intervention, holding its name, duration, department, and list of compatible operating rooms.
- **`models/scheduled_block.dart`** — data model representing a surgery block that has been placed in the schedule, adding room assignment, date, and computed start/end times to an intervention.
- **`pages/home_page.dart`** — landing page shown at startup; provides the two main navigation buttons to reach the intervention insertion and monthly scheduling pages.
- **`pages/intervention_insertion_page.dart`** — manages the list of planned interventions for a selected month; allows staff to add or delete interventions per department and triggers schedule generation.
- **`pages/monthly_scheduling_page.dart`** — displays the generated schedule as a monthly calendar grid, one card per operating room, with color-coded intervention chips and a detail popup.
- **`pages/not_found_page.dart`** — fallback page rendered when an unknown route is requested (404).
- **`services/scheduler.dart`** — contains the greedy two-phase scheduling algorithm that distributes interventions across operating rooms while satisfying all clinical and operational constraints.

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

## Project Status

This project is currently in active development. The core workflow (intervention entry → automatic scheduling → calendar visualization) is fully functional. Planned future improvements may include export to PDF/Excel, manual schedule editing, and multi-user support.

## Authors
<a href="https://github.com/AntonioSouls">
  <img src="https://github.com/AntonioSouls.png" width="80">
</a>
