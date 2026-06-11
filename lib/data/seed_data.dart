// ── Dati di seed v2 ───────────────────────────────────────────────────────────
// Generato automaticamente. Ogni mese (Gen–Ott 2026): 7 reparti,
// ciascuno con interventi che sommano a 18.000 min (tot 126.000 min/mese).
// Tutte le 5 sale compatibili. Durate: 2h–6h, variate per mese.
//
// Per resettare il localStorage basta incrementare kSeedVersion e fare
// Hot Restart: tutti i dati precedenti vengono cancellati e ricaricati
// da questo seed.
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:math';

/// Cambia questo valore per forzare il reset del localStorage al prossimo avvio.
const String kSeedVersion = 'v2';

/// Genera una lista di interventi mescolando casualmente [durs] con [rngSeed].
/// Tutti compatibili con le sale 1–5.
List<Map<String, Object>> _build(
    String dept, List<(int, int)> durs, int rngSeed) {
  final shuffled = [...durs]..shuffle(Random(rngSeed));
  return List.generate(shuffled.length, (i) {
    final (h, m) = shuffled[i];
    return {
      'name': '$dept ${i + 1}',
      'hours': h,
      'minutes': m,
      'compatibleRoomIds': <int>[1, 2, 3, 4, 5],
    };
  });
}

// ── Distribuzioni durate per mese (per reparto, somma = 18.000 min) ───────────
//
// Gennaio  : 30×2h + 20×3h + 45×4h              = 3600+3600+10800 = 18.000 ✓
// Febbraio : 40×2h + 10×3h + 10×4h + 30×5h      = 4800+1800+2400+9000 = 18.000 ✓
// Marzo    : 20×2h + 30×3h + 20×4h + 18×5h      = 2400+5400+4800+5400 = 18.000 ✓
// Aprile   : 10×2h + 50×3h + 10×4h + 15×6h      = 1200+9000+2400+5400 = 18.000 ✓
// Maggio   : 30×2h + 20×3h + 25×4h + 10×5h + 5×6h = 3600+3600+6000+3000+1800 = 18.000 ✓
// Giugno   : 60×2h + 10×3h + 30×4h + 5×6h       = 7200+1800+7200+1800 = 18.000 ✓
// Luglio   : 5×2h + 60×3h + 22×5h               = 600+10800+6600 = 18.000 ✓
// Agosto   : 20×2h + 5×3h + 55×4h + 5×5h        = 2400+900+13200+1500 = 18.000 ✓
// Settembre: 15×2h + 40×3h + 10×4h + 22×5h      = 1800+7200+2400+6600 = 18.000 ✓
// Ottobre  : 40×2h + 15×4h + 20×5h + 10×6h      = 4800+3600+6000+3600 = 18.000 ✓

final _dursJan = [
  ...List.filled(30, (2, 0)),
  ...List.filled(20, (3, 0)),
  ...List.filled(45, (4, 0)),
];

final _dursFeb = [
  ...List.filled(40, (2, 0)),
  ...List.filled(10, (3, 0)),
  ...List.filled(10, (4, 0)),
  ...List.filled(30, (5, 0)),
];

final _dursMar = [
  ...List.filled(20, (2, 0)),
  ...List.filled(30, (3, 0)),
  ...List.filled(20, (4, 0)),
  ...List.filled(18, (5, 0)),
];

final _dursApr = [
  ...List.filled(10, (2, 0)),
  ...List.filled(50, (3, 0)),
  ...List.filled(10, (4, 0)),
  ...List.filled(15, (6, 0)),
];

final _dursMay = [
  ...List.filled(30, (2, 0)),
  ...List.filled(20, (3, 0)),
  ...List.filled(25, (4, 0)),
  ...List.filled(10, (5, 0)),
  ...List.filled( 5, (6, 0)),
];

final _dursJun = [
  ...List.filled(60, (2, 0)),
  ...List.filled(10, (3, 0)),
  ...List.filled(30, (4, 0)),
  ...List.filled( 5, (6, 0)),
];

final _dursJul = [
  ...List.filled( 5, (2, 0)),
  ...List.filled(60, (3, 0)),
  ...List.filled(22, (5, 0)),
];

final _dursAug = [
  ...List.filled(20, (2, 0)),
  ...List.filled( 5, (3, 0)),
  ...List.filled(55, (4, 0)),
  ...List.filled( 5, (5, 0)),
];

final _dursSep = [
  ...List.filled(15, (2, 0)),
  ...List.filled(40, (3, 0)),
  ...List.filled(10, (4, 0)),
  ...List.filled(22, (5, 0)),
];

final _dursOct = [
  ...List.filled(40, (2, 0)),
  ...List.filled(15, (4, 0)),
  ...List.filled(20, (5, 0)),
  ...List.filled(10, (6, 0)),
];

// ── Distribuzioni durate 2027 (1h–8h, somma = 18.000 min per reparto) ─────────
//
// Gennaio  : 50×1h + 30×3h + 20×8h              = 3000+5400+9600 = 18.000 ✓
// Febbraio : 10×1h + 30×2h + 20×3h + 20×5h + 10×7h = 600+3600+3600+6000+4200 = 18.000 ✓
// Marzo    : 30×2h + 20×6h + 15×8h              = 3600+7200+7200 = 18.000 ✓
// Aprile   : 40×1h + 20×4h + 20×5h + 10×8h     = 2400+4800+6000+4800 = 18.000 ✓
// Maggio   : 15×2h + 30×3h + 25×4h + 10×8h     = 1800+5400+6000+4800 = 18.000 ✓
// Giugno   : 80×1h + 40×2h + 20×7h             = 4800+4800+8400 = 18.000 ✓
// Luglio   : 20×2h + 20×6h + 20×7h             = 2400+7200+8400 = 18.000 ✓
// Agosto   : 10×1h + 30×2h + 10×3h + 25×8h     = 600+3600+1800+12000 = 18.000 ✓
// Settembre: 45×1h+20×2h+15×3h+10×4h+5×5h+5×6h+5×7h+5×8h = 2700+2400+2700+2400+1500+1800+2100+2400 = 18.000 ✓
// Ottobre  : 50×1h + 10×5h + 25×8h             = 3000+3000+12000 = 18.000 ✓

final _dursJan27 = [
  ...List.filled(50, (1, 0)),
  ...List.filled(30, (3, 0)),
  ...List.filled(20, (8, 0)),
];

final _dursFeb27 = [
  ...List.filled(10, (1, 0)),
  ...List.filled(30, (2, 0)),
  ...List.filled(20, (3, 0)),
  ...List.filled(20, (5, 0)),
  ...List.filled(10, (7, 0)),
];

final _dursMar27 = [
  ...List.filled(30, (2, 0)),
  ...List.filled(20, (6, 0)),
  ...List.filled(15, (8, 0)),
];

final _dursApr27 = [
  ...List.filled(40, (1, 0)),
  ...List.filled(20, (4, 0)),
  ...List.filled(20, (5, 0)),
  ...List.filled(10, (8, 0)),
];

final _dursMay27 = [
  ...List.filled(15, (2, 0)),
  ...List.filled(30, (3, 0)),
  ...List.filled(25, (4, 0)),
  ...List.filled(10, (8, 0)),
];

final _dursJun27 = [
  ...List.filled(80, (1, 0)),
  ...List.filled(40, (2, 0)),
  ...List.filled(20, (7, 0)),
];

final _dursJul27 = [
  ...List.filled(20, (2, 0)),
  ...List.filled(20, (6, 0)),
  ...List.filled(20, (7, 0)),
];

final _dursAug27 = [
  ...List.filled(10, (1, 0)),
  ...List.filled(30, (2, 0)),
  ...List.filled(10, (3, 0)),
  ...List.filled(25, (8, 0)),
];

final _dursSep27 = [
  ...List.filled(45, (1, 0)),
  ...List.filled(20, (2, 0)),
  ...List.filled(15, (3, 0)),
  ...List.filled(10, (4, 0)),
  ...List.filled( 5, (5, 0)),
  ...List.filled( 5, (6, 0)),
  ...List.filled( 5, (7, 0)),
  ...List.filled( 5, (8, 0)),
];

final _dursOct27 = [
  ...List.filled(50, (1, 0)),
  ...List.filled(10, (5, 0)),
  ...List.filled(25, (8, 0)),
];

// ── Distribuzioni 2028 — Neuro (d5) e Cardio (d6) ≈ 75% dei minuti ──────────
// Ogni mese: 2×N + 5×S = 126.000 min.
// N = minuti per Neurochirurgia/Cardiochirurgia, S = minuti per ciascuno degli altri 5.
//
//  Jan: N=48.000, S= 6.000 → 76 %   Jun: N=48.000, S= 6.000 → 76 %
//  Feb: N=45.000, S= 7.200 → 71 %   Jul: N=45.000, S= 7.200 → 71 %
//  Mar: N=48.600, S= 5.760 → 77 %   Aug: N=48.600, S= 5.760 → 77 %
//  Apr: N=50.400, S= 5.040 → 80 %   Sep: N=50.400, S= 5.040 → 80 %
//  May: N=46.800, S= 6.480 → 74 %   Oct: N=46.800, S= 6.480 → 74 %

// Neuro/Cardio — Gennaio 2028  (48.000): 15×2h+50×4h+90×5h+20×6h
final _ncJan28 = [
  ...List.filled(15, (2, 0)), ...List.filled(50, (4, 0)),
  ...List.filled(90, (5, 0)), ...List.filled(20, (6, 0)),
];
// Neuro/Cardio — Febbraio 2028 (45.000): 75×2h+50×4h+50×5h+25×6h
final _ncFeb28 = [
  ...List.filled(75, (2, 0)), ...List.filled(50, (4, 0)),
  ...List.filled(50, (5, 0)), ...List.filled(25, (6, 0)),
];
// Neuro/Cardio — Marzo 2028    (48.600): 30×2h+50×4h+50×5h+50×6h
final _ncMar28 = [
  ...List.filled(30, (2, 0)), ...List.filled(50, (4, 0)),
  ...List.filled(50, (5, 0)), ...List.filled(50, (6, 0)),
];
// Neuro/Cardio — Aprile 2028   (50.400): 50×2h+80×4h+60×5h+20×6h
final _ncApr28 = [
  ...List.filled(50, (2, 0)), ...List.filled(80, (4, 0)),
  ...List.filled(60, (5, 0)), ...List.filled(20, (6, 0)),
];
// Neuro/Cardio — Maggio 2028   (46.800): 100×2h+100×4h+30×6h
final _ncMay28 = [
  ...List.filled(100, (2, 0)), ...List.filled(100, (4, 0)),
  ...List.filled( 30, (6, 0)),
];
// Neuro/Cardio — Giugno 2028   (48.000): 60×2h+40×3h+20×4h+80×6h
final _ncJun28 = [
  ...List.filled(60, (2, 0)), ...List.filled(40, (3, 0)),
  ...List.filled(20, (4, 0)), ...List.filled(80, (6, 0)),
];
// Neuro/Cardio — Luglio 2028   (45.000): 50×2h+50×3h+100×5h
final _ncJul28 = [
  ...List.filled(50, (2, 0)), ...List.filled(50, (3, 0)),
  ...List.filled(100, (5, 0)),
];
// Neuro/Cardio — Agosto 2028   (48.600): 45×2h+50×3h+80×4h+50×5h
final _ncAug28 = [
  ...List.filled(45, (2, 0)), ...List.filled(50, (3, 0)),
  ...List.filled(80, (4, 0)), ...List.filled(50, (5, 0)),
];
// Neuro/Cardio — Settembre 2028(50.400): 40×2h+80×4h+40×5h+40×6h
final _ncSep28 = [
  ...List.filled(40, (2, 0)), ...List.filled(80, (4, 0)),
  ...List.filled(40, (5, 0)), ...List.filled(40, (6, 0)),
];
// Neuro/Cardio — Ottobre 2028  (46.800): 75×2h+90×5h+30×6h
final _ncOct28 = [
  ...List.filled(75, (2, 0)), ...List.filled(90, (5, 0)),
  ...List.filled(30, (6, 0)),
];

// Reparti minori — Gennaio 2028  (6.000): 15×2h+10×3h+10×4h
final _smJan28 = [
  ...List.filled(15, (2, 0)), ...List.filled(10, (3, 0)),
  ...List.filled(10, (4, 0)),
];
// Reparti minori — Febbraio 2028 (7.200): 10×2h+10×3h+10×4h+5×6h
final _smFeb28 = [
  ...List.filled(10, (2, 0)), ...List.filled(10, (3, 0)),
  ...List.filled(10, (4, 0)), ...List.filled( 5, (6, 0)),
];
// Reparti minori — Marzo 2028    (5.760): 20×2h+8×4h+4×6h
final _smMar28 = [
  ...List.filled(20, (2, 0)), ...List.filled(8, (4, 0)),
  ...List.filled( 4, (6, 0)),
];
// Reparti minori — Aprile 2028   (5.040): 7×3h+7×4h+7×5h
final _smApr28 = [
  ...List.filled(7, (3, 0)), ...List.filled(7, (4, 0)),
  ...List.filled(7, (5, 0)),
];
// Reparti minori — Maggio 2028   (6.480): 9×3h+9×4h+9×5h
final _smMay28 = [
  ...List.filled(9, (3, 0)), ...List.filled(9, (4, 0)),
  ...List.filled(9, (5, 0)),
];
// Reparti minori — Giugno 2028   (6.000): 25×2h+5×4h+5×6h
final _smJun28 = [
  ...List.filled(25, (2, 0)), ...List.filled(5, (4, 0)),
  ...List.filled( 5, (6, 0)),
];
// Reparti minori — Luglio 2028   (7.200): 15×2h+20×3h+5×6h
final _smJul28 = [
  ...List.filled(15, (2, 0)), ...List.filled(20, (3, 0)),
  ...List.filled( 5, (6, 0)),
];
// Reparti minori — Agosto 2028   (5.760): 34×2h+4×4h+2×6h
final _smAug28 = [
  ...List.filled(34, (2, 0)), ...List.filled(4, (4, 0)),
  ...List.filled( 2, (6, 0)),
];
// Reparti minori — Settembre 2028(5.040): 7×2h+14×5h
final _smSep28 = [
  ...List.filled( 7, (2, 0)), ...List.filled(14, (5, 0)),
];
// Reparti minori — Ottobre 2028  (6.480): 12×2h+6×3h+12×4h+3×6h
final _smOct28 = [
  ...List.filled(12, (2, 0)), ...List.filled( 6, (3, 0)),
  ...List.filled(12, (4, 0)), ...List.filled( 3, (6, 0)),
];

// ── Distribuzioni 2029 — stessa struttura 75/25 del 2028, durate 1h–8h ───────
// N/S identici al 2028 per mese (2N+5S=126.000), pattern diversi per varietà.

// Neuro/Cardio — Gennaio 2029  (48.000): 60×2h+100×3h+60×5h+10×8h
final _ncJan29 = [
  ...List.filled( 60, (2, 0)), ...List.filled(100, (3, 0)),
  ...List.filled( 60, (5, 0)), ...List.filled( 10, (8, 0)),
];
// Neuro/Cardio — Febbraio 2029 (45.000): 70×1h+50×3h+100×5h+5×6h
final _ncFeb29 = [
  ...List.filled( 70, (1, 0)), ...List.filled( 50, (3, 0)),
  ...List.filled(100, (5, 0)), ...List.filled(  5, (6, 0)),
];
// Neuro/Cardio — Marzo 2029    (48.600): 70×2h+100×4h+20×6h+10×7h+10×8h
final _ncMar29 = [
  ...List.filled( 70, (2, 0)), ...List.filled(100, (4, 0)),
  ...List.filled( 20, (6, 0)), ...List.filled( 10, (7, 0)),
  ...List.filled( 10, (8, 0)),
];
// Neuro/Cardio — Aprile 2029   (50.400): 20×1h+60×2h+50×4h+50×5h+30×7h+5×8h
final _ncApr29 = [
  ...List.filled( 20, (1, 0)), ...List.filled( 60, (2, 0)),
  ...List.filled( 50, (4, 0)), ...List.filled( 50, (5, 0)),
  ...List.filled( 30, (7, 0)), ...List.filled(  5, (8, 0)),
];
// Neuro/Cardio — Maggio 2029   (46.800): 90×2h+60×3h+60×4h+20×7h+5×8h
final _ncMay29 = [
  ...List.filled( 90, (2, 0)), ...List.filled( 60, (3, 0)),
  ...List.filled( 60, (4, 0)), ...List.filled( 20, (7, 0)),
  ...List.filled(  5, (8, 0)),
];
// Neuro/Cardio — Giugno 2029   (48.000): 100×1h+60×3h+60×5h+20×7h+10×8h
final _ncJun29 = [
  ...List.filled(100, (1, 0)), ...List.filled( 60, (3, 0)),
  ...List.filled( 60, (5, 0)), ...List.filled( 20, (7, 0)),
  ...List.filled( 10, (8, 0)),
];
// Neuro/Cardio — Luglio 2029   (45.000): 50×1h+50×2h+60×4h+60×5h+10×6h
final _ncJul29 = [
  ...List.filled( 50, (1, 0)), ...List.filled( 50, (2, 0)),
  ...List.filled( 60, (4, 0)), ...List.filled( 60, (5, 0)),
  ...List.filled( 10, (6, 0)),
];
// Neuro/Cardio — Agosto 2029   (48.600): 90×2h+80×4h+30×5h+20×8h
final _ncAug29 = [
  ...List.filled( 90, (2, 0)), ...List.filled( 80, (4, 0)),
  ...List.filled( 30, (5, 0)), ...List.filled( 20, (8, 0)),
];
// Neuro/Cardio — Settembre 2029(50.400): 150×2h+50×4h+30×6h+20×8h
final _ncSep29 = [
  ...List.filled(150, (2, 0)), ...List.filled( 50, (4, 0)),
  ...List.filled( 30, (6, 0)), ...List.filled( 20, (8, 0)),
];
// Neuro/Cardio — Ottobre 2029  (46.800): 105×2h+80×5h+10×6h+10×7h+5×8h
final _ncOct29 = [
  ...List.filled(105, (2, 0)), ...List.filled( 80, (5, 0)),
  ...List.filled( 10, (6, 0)), ...List.filled( 10, (7, 0)),
  ...List.filled(  5, (8, 0)),
];

// Reparti minori — Gennaio 2029  (6.000): 20×1h+10×4h+5×8h
final _smJan29 = [
  ...List.filled(20, (1, 0)), ...List.filled(10, (4, 0)),
  ...List.filled( 5, (8, 0)),
];
// Reparti minori — Febbraio 2029 (7.200): 40×1h+20×2h+5×8h
final _smFeb29 = [
  ...List.filled(40, (1, 0)), ...List.filled(20, (2, 0)),
  ...List.filled( 5, (8, 0)),
];
// Reparti minori — Marzo 2029    (5.760): 26×1h+10×3h+10×4h
final _smMar29 = [
  ...List.filled(26, (1, 0)), ...List.filled(10, (3, 0)),
  ...List.filled(10, (4, 0)),
];
// Reparti minori — Aprile 2029   (5.040): 24×1h+10×3h+5×6h
final _smApr29 = [
  ...List.filled(24, (1, 0)), ...List.filled(10, (3, 0)),
  ...List.filled( 5, (6, 0)),
];
// Reparti minori — Maggio 2029   (6.480): 13×1h+15×4h+5×7h
final _smMay29 = [
  ...List.filled(13, (1, 0)), ...List.filled(15, (4, 0)),
  ...List.filled( 5, (7, 0)),
];
// Reparti minori — Giugno 2029   (6.000): 45×1h+10×2h+5×7h
final _smJun29 = [
  ...List.filled(45, (1, 0)), ...List.filled(10, (2, 0)),
  ...List.filled( 5, (7, 0)),
];
// Reparti minori — Luglio 2029   (7.200): 40×1h+10×3h+10×5h
final _smJul29 = [
  ...List.filled(40, (1, 0)), ...List.filled(10, (3, 0)),
  ...List.filled(10, (5, 0)),
];
// Reparti minori — Agosto 2029   (5.760): 24×1h+12×4h+4×6h
final _smAug29 = [
  ...List.filled(24, (1, 0)), ...List.filled(12, (4, 0)),
  ...List.filled( 4, (6, 0)),
];
// Reparti minori — Settembre 2029(5.040): 14×1h+7×4h+7×6h
final _smSep29 = [
  ...List.filled(14, (1, 0)), ...List.filled(7, (4, 0)),
  ...List.filled( 7, (6, 0)),
];
// Reparti minori — Ottobre 2029  (6.480): 10×1h+10×3h+10×4h+4×7h
final _smOct29 = [
  ...List.filled(10, (1, 0)), ...List.filled(10, (3, 0)),
  ...List.filled(10, (4, 0)), ...List.filled( 4, (7, 0)),
];

// ── Nomi reparti ──────────────────────────────────────────────────────────────
const _d1 = 'Chirurgia Generale';
const _d2 = 'Ortopedia';
const _d3 = 'Ginecologia';
const _d4 = 'Urologia';
const _d5 = 'Neurochirurgia';
const _d6 = 'Cardiochirurgia';
const _d7 = 'Otorinolaringoiatria';

// ── Seed map ──────────────────────────────────────────────────────────────────
final Map<String, List<Map<String, Object>>> kSeedData = {
  // ── Gennaio 2026 — 30×2h + 20×3h + 45×4h = 95 interventi/reparto ─────────
  '2026_1_1': _build(_d1, _dursJan, 1101),
  '2026_1_2': _build(_d2, _dursJan, 1102),
  '2026_1_3': _build(_d3, _dursJan, 1103),
  '2026_1_4': _build(_d4, _dursJan, 1104),
  '2026_1_5': _build(_d5, _dursJan, 1105),
  '2026_1_6': _build(_d6, _dursJan, 1106),
  '2026_1_7': _build(_d7, _dursJan, 1107),

  // ── Febbraio 2026 — 40×2h + 10×3h + 10×4h + 30×5h = 90 interventi/reparto
  '2026_2_1': _build(_d1, _dursFeb, 2201),
  '2026_2_2': _build(_d2, _dursFeb, 2202),
  '2026_2_3': _build(_d3, _dursFeb, 2203),
  '2026_2_4': _build(_d4, _dursFeb, 2204),
  '2026_2_5': _build(_d5, _dursFeb, 2205),
  '2026_2_6': _build(_d6, _dursFeb, 2206),
  '2026_2_7': _build(_d7, _dursFeb, 2207),

  // ── Marzo 2026 — 20×2h + 30×3h + 20×4h + 18×5h = 88 interventi/reparto ──
  '2026_3_1': _build(_d1, _dursMar, 3301),
  '2026_3_2': _build(_d2, _dursMar, 3302),
  '2026_3_3': _build(_d3, _dursMar, 3303),
  '2026_3_4': _build(_d4, _dursMar, 3304),
  '2026_3_5': _build(_d5, _dursMar, 3305),
  '2026_3_6': _build(_d6, _dursMar, 3306),
  '2026_3_7': _build(_d7, _dursMar, 3307),

  // ── Aprile 2026 — 10×2h + 50×3h + 10×4h + 15×6h = 85 interventi/reparto ─
  '2026_4_1': _build(_d1, _dursApr, 4401),
  '2026_4_2': _build(_d2, _dursApr, 4402),
  '2026_4_3': _build(_d3, _dursApr, 4403),
  '2026_4_4': _build(_d4, _dursApr, 4404),
  '2026_4_5': _build(_d5, _dursApr, 4405),
  '2026_4_6': _build(_d6, _dursApr, 4406),
  '2026_4_7': _build(_d7, _dursApr, 4407),

  // ── Maggio 2026 — 30×2h+20×3h+25×4h+10×5h+5×6h = 90 interventi/reparto ─
  '2026_5_1': _build(_d1, _dursMay, 5501),
  '2026_5_2': _build(_d2, _dursMay, 5502),
  '2026_5_3': _build(_d3, _dursMay, 5503),
  '2026_5_4': _build(_d4, _dursMay, 5504),
  '2026_5_5': _build(_d5, _dursMay, 5505),
  '2026_5_6': _build(_d6, _dursMay, 5506),
  '2026_5_7': _build(_d7, _dursMay, 5507),

  // ── Giugno 2026 — 60×2h + 10×3h + 30×4h + 5×6h = 105 interventi/reparto ─
  '2026_6_1': _build(_d1, _dursJun, 6601),
  '2026_6_2': _build(_d2, _dursJun, 6602),
  '2026_6_3': _build(_d3, _dursJun, 6603),
  '2026_6_4': _build(_d4, _dursJun, 6604),
  '2026_6_5': _build(_d5, _dursJun, 6605),
  '2026_6_6': _build(_d6, _dursJun, 6606),
  '2026_6_7': _build(_d7, _dursJun, 6607),

  // ── Luglio 2026 — 5×2h + 60×3h + 22×5h = 87 interventi/reparto ──────────
  '2026_7_1': _build(_d1, _dursJul, 7701),
  '2026_7_2': _build(_d2, _dursJul, 7702),
  '2026_7_3': _build(_d3, _dursJul, 7703),
  '2026_7_4': _build(_d4, _dursJul, 7704),
  '2026_7_5': _build(_d5, _dursJul, 7705),
  '2026_7_6': _build(_d6, _dursJul, 7706),
  '2026_7_7': _build(_d7, _dursJul, 7707),

  // ── Agosto 2026 — 20×2h + 5×3h + 55×4h + 5×5h = 85 interventi/reparto ──
  '2026_8_1': _build(_d1, _dursAug, 8801),
  '2026_8_2': _build(_d2, _dursAug, 8802),
  '2026_8_3': _build(_d3, _dursAug, 8803),
  '2026_8_4': _build(_d4, _dursAug, 8804),
  '2026_8_5': _build(_d5, _dursAug, 8805),
  '2026_8_6': _build(_d6, _dursAug, 8806),
  '2026_8_7': _build(_d7, _dursAug, 8807),

  // ── Settembre 2026 — 15×2h + 40×3h + 10×4h + 22×5h = 87 interventi/reparto
  '2026_9_1': _build(_d1, _dursSep, 9901),
  '2026_9_2': _build(_d2, _dursSep, 9902),
  '2026_9_3': _build(_d3, _dursSep, 9903),
  '2026_9_4': _build(_d4, _dursSep, 9904),
  '2026_9_5': _build(_d5, _dursSep, 9905),
  '2026_9_6': _build(_d6, _dursSep, 9906),
  '2026_9_7': _build(_d7, _dursSep, 9907),

  // ── Ottobre 2026 — 40×2h + 15×4h + 20×5h + 10×6h = 85 interventi/reparto
  '2026_10_1': _build(_d1, _dursOct, 10001),
  '2026_10_2': _build(_d2, _dursOct, 10002),
  '2026_10_3': _build(_d3, _dursOct, 10003),
  '2026_10_4': _build(_d4, _dursOct, 10004),
  '2026_10_5': _build(_d5, _dursOct, 10005),
  '2026_10_6': _build(_d6, _dursOct, 10006),
  '2026_10_7': _build(_d7, _dursOct, 10007),

  // ── Gennaio 2027 — 50×1h + 30×3h + 20×8h = 100 interventi/reparto ────────
  '2027_1_1': _build(_d1, _dursJan27, 11101),
  '2027_1_2': _build(_d2, _dursJan27, 11102),
  '2027_1_3': _build(_d3, _dursJan27, 11103),
  '2027_1_4': _build(_d4, _dursJan27, 11104),
  '2027_1_5': _build(_d5, _dursJan27, 11105),
  '2027_1_6': _build(_d6, _dursJan27, 11106),
  '2027_1_7': _build(_d7, _dursJan27, 11107),

  // ── Febbraio 2027 — 10×1h+30×2h+20×3h+20×5h+10×7h = 90 interventi/reparto
  '2027_2_1': _build(_d1, _dursFeb27, 12201),
  '2027_2_2': _build(_d2, _dursFeb27, 12202),
  '2027_2_3': _build(_d3, _dursFeb27, 12203),
  '2027_2_4': _build(_d4, _dursFeb27, 12204),
  '2027_2_5': _build(_d5, _dursFeb27, 12205),
  '2027_2_6': _build(_d6, _dursFeb27, 12206),
  '2027_2_7': _build(_d7, _dursFeb27, 12207),

  // ── Marzo 2027 — 30×2h + 20×6h + 15×8h = 65 interventi/reparto ──────────
  '2027_3_1': _build(_d1, _dursMar27, 13301),
  '2027_3_2': _build(_d2, _dursMar27, 13302),
  '2027_3_3': _build(_d3, _dursMar27, 13303),
  '2027_3_4': _build(_d4, _dursMar27, 13304),
  '2027_3_5': _build(_d5, _dursMar27, 13305),
  '2027_3_6': _build(_d6, _dursMar27, 13306),
  '2027_3_7': _build(_d7, _dursMar27, 13307),

  // ── Aprile 2027 — 40×1h + 20×4h + 20×5h + 10×8h = 90 interventi/reparto ─
  '2027_4_1': _build(_d1, _dursApr27, 14401),
  '2027_4_2': _build(_d2, _dursApr27, 14402),
  '2027_4_3': _build(_d3, _dursApr27, 14403),
  '2027_4_4': _build(_d4, _dursApr27, 14404),
  '2027_4_5': _build(_d5, _dursApr27, 14405),
  '2027_4_6': _build(_d6, _dursApr27, 14406),
  '2027_4_7': _build(_d7, _dursApr27, 14407),

  // ── Maggio 2027 — 15×2h + 30×3h + 25×4h + 10×8h = 80 interventi/reparto ─
  '2027_5_1': _build(_d1, _dursMay27, 15501),
  '2027_5_2': _build(_d2, _dursMay27, 15502),
  '2027_5_3': _build(_d3, _dursMay27, 15503),
  '2027_5_4': _build(_d4, _dursMay27, 15504),
  '2027_5_5': _build(_d5, _dursMay27, 15505),
  '2027_5_6': _build(_d6, _dursMay27, 15506),
  '2027_5_7': _build(_d7, _dursMay27, 15507),

  // ── Giugno 2027 — 80×1h + 40×2h + 20×7h = 140 interventi/reparto ─────────
  '2027_6_1': _build(_d1, _dursJun27, 16601),
  '2027_6_2': _build(_d2, _dursJun27, 16602),
  '2027_6_3': _build(_d3, _dursJun27, 16603),
  '2027_6_4': _build(_d4, _dursJun27, 16604),
  '2027_6_5': _build(_d5, _dursJun27, 16605),
  '2027_6_6': _build(_d6, _dursJun27, 16606),
  '2027_6_7': _build(_d7, _dursJun27, 16607),

  // ── Luglio 2027 — 20×2h + 20×6h + 20×7h = 60 interventi/reparto ──────────
  '2027_7_1': _build(_d1, _dursJul27, 17701),
  '2027_7_2': _build(_d2, _dursJul27, 17702),
  '2027_7_3': _build(_d3, _dursJul27, 17703),
  '2027_7_4': _build(_d4, _dursJul27, 17704),
  '2027_7_5': _build(_d5, _dursJul27, 17705),
  '2027_7_6': _build(_d6, _dursJul27, 17706),
  '2027_7_7': _build(_d7, _dursJul27, 17707),

  // ── Agosto 2027 — 10×1h + 30×2h + 10×3h + 25×8h = 75 interventi/reparto ─
  '2027_8_1': _build(_d1, _dursAug27, 18801),
  '2027_8_2': _build(_d2, _dursAug27, 18802),
  '2027_8_3': _build(_d3, _dursAug27, 18803),
  '2027_8_4': _build(_d4, _dursAug27, 18804),
  '2027_8_5': _build(_d5, _dursAug27, 18805),
  '2027_8_6': _build(_d6, _dursAug27, 18806),
  '2027_8_7': _build(_d7, _dursAug27, 18807),

  // ── Settembre 2027 — 45×1h+20×2h+15×3h+10×4h+5×5h+5×6h+5×7h+5×8h = 110/rep
  '2027_9_1': _build(_d1, _dursSep27, 19901),
  '2027_9_2': _build(_d2, _dursSep27, 19902),
  '2027_9_3': _build(_d3, _dursSep27, 19903),
  '2027_9_4': _build(_d4, _dursSep27, 19904),
  '2027_9_5': _build(_d5, _dursSep27, 19905),
  '2027_9_6': _build(_d6, _dursSep27, 19906),
  '2027_9_7': _build(_d7, _dursSep27, 19907),

  // ── Ottobre 2027 — 50×1h + 10×5h + 25×8h = 85 interventi/reparto ─────────
  '2027_10_1': _build(_d1, _dursOct27, 20001),
  '2027_10_2': _build(_d2, _dursOct27, 20002),
  '2027_10_3': _build(_d3, _dursOct27, 20003),
  '2027_10_4': _build(_d4, _dursOct27, 20004),
  '2027_10_5': _build(_d5, _dursOct27, 20005),
  '2027_10_6': _build(_d6, _dursOct27, 20006),
  '2027_10_7': _build(_d7, _dursOct27, 20007),

  // ── Gennaio 2028 — N=48.000 (Neuro/Cardio), S=6.000 (altri) → 76% ────────
  '2028_1_1': _build(_d1, _smJan28, 21101),
  '2028_1_2': _build(_d2, _smJan28, 21102),
  '2028_1_3': _build(_d3, _smJan28, 21103),
  '2028_1_4': _build(_d4, _smJan28, 21104),
  '2028_1_5': _build(_d5, _ncJan28, 21105),
  '2028_1_6': _build(_d6, _ncJan28, 21106),
  '2028_1_7': _build(_d7, _smJan28, 21107),

  // ── Febbraio 2028 — N=45.000, S=7.200 → 71% ─────────────────────────────
  '2028_2_1': _build(_d1, _smFeb28, 22201),
  '2028_2_2': _build(_d2, _smFeb28, 22202),
  '2028_2_3': _build(_d3, _smFeb28, 22203),
  '2028_2_4': _build(_d4, _smFeb28, 22204),
  '2028_2_5': _build(_d5, _ncFeb28, 22205),
  '2028_2_6': _build(_d6, _ncFeb28, 22206),
  '2028_2_7': _build(_d7, _smFeb28, 22207),

  // ── Marzo 2028 — N=48.600, S=5.760 → 77% ────────────────────────────────
  '2028_3_1': _build(_d1, _smMar28, 23301),
  '2028_3_2': _build(_d2, _smMar28, 23302),
  '2028_3_3': _build(_d3, _smMar28, 23303),
  '2028_3_4': _build(_d4, _smMar28, 23304),
  '2028_3_5': _build(_d5, _ncMar28, 23305),
  '2028_3_6': _build(_d6, _ncMar28, 23306),
  '2028_3_7': _build(_d7, _smMar28, 23307),

  // ── Aprile 2028 — N=50.400, S=5.040 → 80% ───────────────────────────────
  '2028_4_1': _build(_d1, _smApr28, 24401),
  '2028_4_2': _build(_d2, _smApr28, 24402),
  '2028_4_3': _build(_d3, _smApr28, 24403),
  '2028_4_4': _build(_d4, _smApr28, 24404),
  '2028_4_5': _build(_d5, _ncApr28, 24405),
  '2028_4_6': _build(_d6, _ncApr28, 24406),
  '2028_4_7': _build(_d7, _smApr28, 24407),

  // ── Maggio 2028 — N=46.800, S=6.480 → 74% ───────────────────────────────
  '2028_5_1': _build(_d1, _smMay28, 25501),
  '2028_5_2': _build(_d2, _smMay28, 25502),
  '2028_5_3': _build(_d3, _smMay28, 25503),
  '2028_5_4': _build(_d4, _smMay28, 25504),
  '2028_5_5': _build(_d5, _ncMay28, 25505),
  '2028_5_6': _build(_d6, _ncMay28, 25506),
  '2028_5_7': _build(_d7, _smMay28, 25507),

  // ── Giugno 2028 — N=48.000, S=6.000 → 76% ───────────────────────────────
  '2028_6_1': _build(_d1, _smJun28, 26601),
  '2028_6_2': _build(_d2, _smJun28, 26602),
  '2028_6_3': _build(_d3, _smJun28, 26603),
  '2028_6_4': _build(_d4, _smJun28, 26604),
  '2028_6_5': _build(_d5, _ncJun28, 26605),
  '2028_6_6': _build(_d6, _ncJun28, 26606),
  '2028_6_7': _build(_d7, _smJun28, 26607),

  // ── Luglio 2028 — N=45.000, S=7.200 → 71% ───────────────────────────────
  '2028_7_1': _build(_d1, _smJul28, 27701),
  '2028_7_2': _build(_d2, _smJul28, 27702),
  '2028_7_3': _build(_d3, _smJul28, 27703),
  '2028_7_4': _build(_d4, _smJul28, 27704),
  '2028_7_5': _build(_d5, _ncJul28, 27705),
  '2028_7_6': _build(_d6, _ncJul28, 27706),
  '2028_7_7': _build(_d7, _smJul28, 27707),

  // ── Agosto 2028 — N=48.600, S=5.760 → 77% ───────────────────────────────
  '2028_8_1': _build(_d1, _smAug28, 28801),
  '2028_8_2': _build(_d2, _smAug28, 28802),
  '2028_8_3': _build(_d3, _smAug28, 28803),
  '2028_8_4': _build(_d4, _smAug28, 28804),
  '2028_8_5': _build(_d5, _ncAug28, 28805),
  '2028_8_6': _build(_d6, _ncAug28, 28806),
  '2028_8_7': _build(_d7, _smAug28, 28807),

  // ── Settembre 2028 — N=50.400, S=5.040 → 80% ────────────────────────────
  '2028_9_1': _build(_d1, _smSep28, 29901),
  '2028_9_2': _build(_d2, _smSep28, 29902),
  '2028_9_3': _build(_d3, _smSep28, 29903),
  '2028_9_4': _build(_d4, _smSep28, 29904),
  '2028_9_5': _build(_d5, _ncSep28, 29905),
  '2028_9_6': _build(_d6, _ncSep28, 29906),
  '2028_9_7': _build(_d7, _smSep28, 29907),

  // ── Ottobre 2028 — N=46.800, S=6.480 → 74% ──────────────────────────────
  '2028_10_1': _build(_d1, _smOct28, 30001),
  '2028_10_2': _build(_d2, _smOct28, 30002),
  '2028_10_3': _build(_d3, _smOct28, 30003),
  '2028_10_4': _build(_d4, _smOct28, 30004),
  '2028_10_5': _build(_d5, _ncOct28, 30005),
  '2028_10_6': _build(_d6, _ncOct28, 30006),
  '2028_10_7': _build(_d7, _smOct28, 30007),

  // ── Gennaio 2029 — N=48.000, S=6.000 → 76% ──────────────────────────────
  '2029_1_1': _build(_d1, _smJan29, 31101),
  '2029_1_2': _build(_d2, _smJan29, 31102),
  '2029_1_3': _build(_d3, _smJan29, 31103),
  '2029_1_4': _build(_d4, _smJan29, 31104),
  '2029_1_5': _build(_d5, _ncJan29, 31105),
  '2029_1_6': _build(_d6, _ncJan29, 31106),
  '2029_1_7': _build(_d7, _smJan29, 31107),

  // ── Febbraio 2029 — N=45.000, S=7.200 → 71% ─────────────────────────────
  '2029_2_1': _build(_d1, _smFeb29, 32201),
  '2029_2_2': _build(_d2, _smFeb29, 32202),
  '2029_2_3': _build(_d3, _smFeb29, 32203),
  '2029_2_4': _build(_d4, _smFeb29, 32204),
  '2029_2_5': _build(_d5, _ncFeb29, 32205),
  '2029_2_6': _build(_d6, _ncFeb29, 32206),
  '2029_2_7': _build(_d7, _smFeb29, 32207),

  // ── Marzo 2029 — N=48.600, S=5.760 → 77% ────────────────────────────────
  '2029_3_1': _build(_d1, _smMar29, 33301),
  '2029_3_2': _build(_d2, _smMar29, 33302),
  '2029_3_3': _build(_d3, _smMar29, 33303),
  '2029_3_4': _build(_d4, _smMar29, 33304),
  '2029_3_5': _build(_d5, _ncMar29, 33305),
  '2029_3_6': _build(_d6, _ncMar29, 33306),
  '2029_3_7': _build(_d7, _smMar29, 33307),

  // ── Aprile 2029 — N=50.400, S=5.040 → 80% ───────────────────────────────
  '2029_4_1': _build(_d1, _smApr29, 34401),
  '2029_4_2': _build(_d2, _smApr29, 34402),
  '2029_4_3': _build(_d3, _smApr29, 34403),
  '2029_4_4': _build(_d4, _smApr29, 34404),
  '2029_4_5': _build(_d5, _ncApr29, 34405),
  '2029_4_6': _build(_d6, _ncApr29, 34406),
  '2029_4_7': _build(_d7, _smApr29, 34407),

  // ── Maggio 2029 — N=46.800, S=6.480 → 74% ───────────────────────────────
  '2029_5_1': _build(_d1, _smMay29, 35501),
  '2029_5_2': _build(_d2, _smMay29, 35502),
  '2029_5_3': _build(_d3, _smMay29, 35503),
  '2029_5_4': _build(_d4, _smMay29, 35504),
  '2029_5_5': _build(_d5, _ncMay29, 35505),
  '2029_5_6': _build(_d6, _ncMay29, 35506),
  '2029_5_7': _build(_d7, _smMay29, 35507),

  // ── Giugno 2029 — N=48.000, S=6.000 → 76% ───────────────────────────────
  '2029_6_1': _build(_d1, _smJun29, 36601),
  '2029_6_2': _build(_d2, _smJun29, 36602),
  '2029_6_3': _build(_d3, _smJun29, 36603),
  '2029_6_4': _build(_d4, _smJun29, 36604),
  '2029_6_5': _build(_d5, _ncJun29, 36605),
  '2029_6_6': _build(_d6, _ncJun29, 36606),
  '2029_6_7': _build(_d7, _smJun29, 36607),

  // ── Luglio 2029 — N=45.000, S=7.200 → 71% ───────────────────────────────
  '2029_7_1': _build(_d1, _smJul29, 37701),
  '2029_7_2': _build(_d2, _smJul29, 37702),
  '2029_7_3': _build(_d3, _smJul29, 37703),
  '2029_7_4': _build(_d4, _smJul29, 37704),
  '2029_7_5': _build(_d5, _ncJul29, 37705),
  '2029_7_6': _build(_d6, _ncJul29, 37706),
  '2029_7_7': _build(_d7, _smJul29, 37707),

  // ── Agosto 2029 — N=48.600, S=5.760 → 77% ───────────────────────────────
  '2029_8_1': _build(_d1, _smAug29, 38801),
  '2029_8_2': _build(_d2, _smAug29, 38802),
  '2029_8_3': _build(_d3, _smAug29, 38803),
  '2029_8_4': _build(_d4, _smAug29, 38804),
  '2029_8_5': _build(_d5, _ncAug29, 38805),
  '2029_8_6': _build(_d6, _ncAug29, 38806),
  '2029_8_7': _build(_d7, _smAug29, 38807),

  // ── Settembre 2029 — N=50.400, S=5.040 → 80% ────────────────────────────
  '2029_9_1': _build(_d1, _smSep29, 39901),
  '2029_9_2': _build(_d2, _smSep29, 39902),
  '2029_9_3': _build(_d3, _smSep29, 39903),
  '2029_9_4': _build(_d4, _smSep29, 39904),
  '2029_9_5': _build(_d5, _ncSep29, 39905),
  '2029_9_6': _build(_d6, _ncSep29, 39906),
  '2029_9_7': _build(_d7, _smSep29, 39907),

  // ── Ottobre 2029 — N=46.800, S=6.480 → 74% ──────────────────────────────
  '2029_10_1': _build(_d1, _smOct29, 40001),
  '2029_10_2': _build(_d2, _smOct29, 40002),
  '2029_10_3': _build(_d3, _smOct29, 40003),
  '2029_10_4': _build(_d4, _smOct29, 40004),
  '2029_10_5': _build(_d5, _ncOct29, 40005),
  '2029_10_6': _build(_d6, _ncOct29, 40006),
  '2029_10_7': _build(_d7, _smOct29, 40007),
};
