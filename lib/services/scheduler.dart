import '../models/intervention.dart';
import '../models/scheduled_block.dart';

// ── Costanti orario ───────────────────────────────────────────────────────────

const int _kStart    = 8 * 60;             // 08:00 → 480 min
const int _kEnd      = 22 * 60;            // 22:00 → 1320 min
const int _kCap      = _kEnd - _kStart;    // 840 min/giorno
const int _kMaxPerDay = 3;                 // max interventi per sala per giorno
const int _kNumRooms  = 5;

// ── Tipi interni ──────────────────────────────────────────────────────────────

class _Task {
  final int deptId;
  final Intervention intervention;
  _Task(this.deptId, this.intervention);
}

/// usage[roomId][day] = lista di (startMin, endMin)
typedef _Usage = Map<int, Map<int, List<(int, int)>>>;

// ── Algoritmo principale ──────────────────────────────────────────────────────

/// Genera la programmazione mensile con euristica greedy two-phase.
///
/// Phase 1 – Vincolo settimanale: almeno 1 intervento a settimana per ogni
///           reparto che ha interventi nel mese.
/// Phase 2 – Massimizzazione utilizzo: schedula i rimanenti con best-fit
///           decreasing. Come secondo obiettivo, preferisce giorni in cui il
///           reparto è già presente, minimizzando i giorni operativi distinti
///           (e quindi il massimo tra i reparti).
List<ScheduledBlock> generateSchedule(
  int year,
  int month,
  Map<int, List<Intervention>> byDept,
) {
  final daysInMonth = DateTime(year, month + 1, 0).day;

  // Inizializza struttura utilizzo sale
  final _Usage usage = {
    for (int r = 1; r <= _kNumRooms; r++)
      r: {for (int d = 1; d <= daysInMonth; d++) d: []},
  };

  final schedule = <ScheduledBlock>[];

  // Raccoglie tutti i task e li ordina per durata decrescente
  // (gli interventi più lunghi sono più difficili da piazzare → prima)
  final tasks = [
    for (final e in byDept.entries)
      for (final inv in e.value) _Task(e.key, inv),
  ]..sort((a, b) =>
      b.intervention.totalMinutes.compareTo(a.intervention.totalMinutes));

  if (tasks.isEmpty) return schedule;

  final remaining = List<_Task>.from(tasks);

  // Settimane: gruppi di 7 giorni a partire dal giorno 1 del mese
  final weeks = [
    for (int d = 1; d <= daysInMonth; d += 7)
      [for (int i = d; i < d + 7 && i <= daysInMonth; i++) i],
  ];

  // ── Phase 1: vincolo settimanale ─────────────────────────────────────────
  for (final week in weeks) {
    for (final deptId in byDept.keys) {
      if (byDept[deptId]!.isEmpty) continue;

      // Il reparto ha già un blocco in questa settimana?
      if (schedule.any((b) => b.deptId == deptId && week.contains(b.day))) {
        continue;
      }

      final idx = remaining.indexWhere((t) => t.deptId == deptId);
      if (idx == -1) continue;

      final slot = _bestSlot(remaining[idx], week, usage, schedule);
      if (slot != null) {
        schedule.add(slot);
        _apply(slot, usage);
        remaining.removeAt(idx);
      }
    }
  }

  // ── Phase 2: massimizzazione utilizzo ────────────────────────────────────
  final allDays = List.generate(daysInMonth, (i) => i + 1);
  for (final task in List<_Task>.from(remaining)) {
    final slot = _bestSlot(task, allDays, usage, schedule);
    if (slot != null) {
      schedule.add(slot);
      _apply(slot, usage);
      remaining.remove(task);
    }
  }

  return schedule;
}

// ── Selezione slot ottimale ───────────────────────────────────────────────────

ScheduledBlock? _bestSlot(
  _Task task,
  List<int> candidateDays,
  _Usage usage,
  List<ScheduledBlock> schedule,
) {
  ScheduledBlock? best;
  int bestScore = -0x7fffffff;
  final dur = task.intervention.totalMinutes;

  for (final roomId in task.intervention.compatibleRoomIds) {
    for (final day in candidateDays) {
      final slots = usage[roomId]![day]!;

      // Vincolo: max 3 interventi per sala per giorno
      if (slots.length >= _kMaxPerDay) continue;

      // Lo slot inizia subito dopo l'ultimo intervento (o alle 8:00)
      final startMin = slots.isEmpty ? _kStart : slots.last.$2;
      final endMin   = startMin + dur;

      // Vincolo: deve terminare entro le 22:00
      if (endMin > _kEnd) continue;

      // Capacità residua dopo aver piazzato questo intervento
      final used      = slots.fold(0, (s, e) => s + (e.$2 - e.$1));
      final afterFree = _kCap - used - dur;

      // Punteggio primario: best-fit → minimizza lo spazio residuo
      //   (score più alto = spazio residuo più piccolo = riempimento migliore)
      // Punteggio secondario: preferisce giorni in cui il reparto è già presente
      //   → riduce i giorni operativi distinti per reparto (2° obiettivo)
      final deptOnDay = schedule.any(
        (b) => b.deptId == task.deptId && b.day == day,
      );
      final score = -afterFree + (deptOnDay ? 100 : 0);

      if (score > bestScore) {
        bestScore = score;
        best = ScheduledBlock(
          interventionName: task.intervention.name,
          deptId: task.deptId,
          roomId: roomId,
          day: day,
          startMinutes: startMin,
          endMinutes: endMin,
        );
      }
    }
  }
  return best;
}

void _apply(ScheduledBlock b, _Usage usage) {
  usage[b.roomId]![b.day]!.add((b.startMinutes, b.endMinutes));
}
