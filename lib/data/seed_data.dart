// ── Dati di seed ─────────────────────────────────────────────────────────────
// Contiene il dataset iniziale dell'app per ogni mese/reparto.
//
// Viene caricato automaticamente la prima volta che si apre un mese/reparto
// per cui il localStorage è ancora vuoto.
// Dopo il primo caricamento i dati vengono salvati in localStorage e
// tutte le modifiche fatte dall'utente sopravvivono ai riavvii.
//
// Per aggiornare i dati: chiedi a Claude di modificare questo file,
// poi premi  R  (Hot Restart) nel terminale.  I dati aggiornati compaiono
// in UI solo per i mesi/reparti non ancora presenti in localStorage
// (oppure dopo aver cancellato manualmente gli interventi di quel mese).
//
// Chiave mappa: 'anno_mese_deptId'
// ─────────────────────────────────────────────────────────────────────────────

/// Genera [n] interventi da 5 h con tutte e 5 le sale compatibili.
List<Map<String, Object>> _gen(String dept, int n) => List.generate(
      n,
      (i) => {
        'name': '$dept ${i + 1}',
        'hours': 5,
        'minutes': 0,
        'compatibleRoomIds': <int>[1, 2, 3, 4, 5],
      },
    );

/// Genera 80 interventi con durate variate che sommano a 18.000 min (300 h)
/// e sale compatibili pseudo-casuali (1–4 sale per intervento).
///
/// Pattern durate (per reparto):
///   20 × 2h + 20 × 3h + 20 × 4h + 10 × 5h + 10 × 7h = 18.000 min
List<Map<String, Object>> _genVaried(String dept) {
  // (ore, minuti) — la lista ha 80 elementi e somma a 18.000 min
  final List<(int, int)> durs = [
    ...List.filled(20, (2, 0)), // 20 × 120 min = 2.400
    ...List.filled(20, (3, 0)), // 20 × 180 min = 3.600
    ...List.filled(20, (4, 0)), // 20 × 240 min = 4.800
    ...List.filled(10, (5, 0)), // 10 × 300 min = 3.000
    ...List.filled(10, (7, 0)), // 10 × 420 min = 4.200
  ]; // totale: 18.000 min ✓

  // 20 combinazioni di sale diverse (1–4 sale); ciclano sugli 80 interventi
  const List<List<int>> rooms = [
    [1, 2, 3], [4, 5],    [1, 3, 5], [2],       [3, 4],
    [1, 5],    [2, 3, 4], [1],       [2, 4, 5], [3],
    [1, 2],    [4],       [1, 3, 4], [5],       [2, 3],
    [1, 2, 4], [3, 5],    [2, 3, 5], [1, 4],    [2, 5],
  ];

  return List.generate(durs.length, (i) {
    final (h, m) = durs[i];
    return {
      'name': '$dept ${i + 1}',
      'hours': h,
      'minutes': m,
      'compatibleRoomIds': <int>[...rooms[i % rooms.length]],
    };
  });
}

final Map<String, List<Map<String, Object>>> kSeedData = {
  // ── Gennaio 2026 ─────────────────────────────────────────────────────────
  '2026_1_2': [
    {'name': 'Ortopedia 1', 'hours': 11, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
  ],
  '2026_1_3': [
    {'name': 'Ginecologia 1', 'hours': 10, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
  ],

  // ── Febbraio 2026 ────────────────────────────────────────────────────────
  '2026_2_5': [
    {'name': 'Neurochirurgia 1', 'hours': 5, 'minutes': 0, 'compatibleRoomIds': <int>[1, 2]},
    {'name': 'Neurochirurgia 2', 'hours': 5, 'minutes': 0, 'compatibleRoomIds': <int>[1, 2]},
    {'name': 'Neurochirurgia 3', 'hours': 5, 'minutes': 0, 'compatibleRoomIds': <int>[1, 2]},
    {'name': 'Neurochirurgia 4', 'hours': 5, 'minutes': 0, 'compatibleRoomIds': <int>[1, 2]},
    {'name': 'Neurochirurgia 5', 'hours': 5, 'minutes': 0, 'compatibleRoomIds': <int>[1, 2]},
  ],

  // ── Marzo 2026 ───────────────────────────────────────────────────────────
  '2026_3_5': [
    {'name': 'Neurochirurgia 1', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Neurochirurgia 2', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Neurochirurgia 3', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Neurochirurgia 4', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Neurochirurgia 5', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Neurochirurgia 6', 'hours': 1, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
  ],
  '2026_3_6': [
    {'name': 'Cardiochirurgia 1', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Cardiochirurgia 2', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Cardiochirurgia 3', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Cardiochirurgia 4', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Cardiochirurgia 5', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Cardiochirurgia 6', 'hours': 1, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
  ],

  // ── Aprile 2026 ──────────────────────────────────────────────────────────
  '2026_4_2': [
    {'name': 'Ortopedia 1', 'hours': 1, 'minutes': 30, 'compatibleRoomIds': <int>[1, 2, 3]},
    {'name': 'Ortopedia 2', 'hours': 1, 'minutes':  0, 'compatibleRoomIds': <int>[1, 2, 3]},
  ],
  '2026_4_6': [
    {'name': 'Cardiochirurgia 1', 'hours': 2, 'minutes':  0, 'compatibleRoomIds': <int>[3, 4, 5]},
    {'name': 'Cardiochirurgia 2', 'hours': 1, 'minutes': 30, 'compatibleRoomIds': <int>[3, 4, 5]},
  ],

  // ── Maggio 2026 ──────────────────────────────────────────────────────────
  '2026_5_3': [
    {'name': 'Ginecologia 1', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Ginecologia 2', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Ginecologia 3', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Ginecologia 4', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Ginecologia 5', 'hours': 2, 'minutes': 0, 'compatibleRoomIds': <int>[1]},
    {'name': 'Ginecologia 6', 'hours': 1, 'minutes': 0, 'compatibleRoomIds': <int>[2]},
  ],

  // ── Giugno 2026 — 60 interventi × 7 reparti = 420 totali ────────────────
  '2026_6_1': _gen('Chirurgia Generale',   60),
  '2026_6_2': _gen('Ortopedia',            60),
  '2026_6_3': _gen('Ginecologia',          60),
  '2026_6_4': _gen('Urologia',             60),
  '2026_6_5': _gen('Neurochirurgia',       60),
  '2026_6_6': _gen('Cardiochirurgia',      60),
  '2026_6_7': _gen('Otorinolaringoiatria', 60),

  // ── Luglio 2026 — 80 interventi × 7 reparti = 560 totali, 126.000 min ───
  // Ogni reparto: 20×2h + 20×3h + 20×4h + 10×5h + 10×7h = 18.000 min
  // 18.000 × 7 = 126.000 min ✓
  '2026_7_1': _genVaried('Chirurgia Generale'),
  '2026_7_2': _genVaried('Ortopedia'),
  '2026_7_3': _genVaried('Ginecologia'),
  '2026_7_4': _genVaried('Urologia'),
  '2026_7_5': _genVaried('Neurochirurgia'),
  '2026_7_6': _genVaried('Cardiochirurgia'),
  '2026_7_7': _genVaried('Otorinolaringoiatria'),
};
