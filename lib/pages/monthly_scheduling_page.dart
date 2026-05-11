import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> _kMonths = [
  'Gennaio', 'Febbraio', 'Marzo', 'Aprile',
  'Maggio', 'Giugno', 'Luglio', 'Agosto',
  'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
];

const List<String> _kDayNames = [
  'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom',
];

// ── Pagina principale ────────────────────────────────────────────────────────

class MonthlySchedulingPage extends StatefulWidget {
  const MonthlySchedulingPage({super.key});

  @override
  State<MonthlySchedulingPage> createState() =>
      _MonthlySchedulingPageState();
}

class _MonthlySchedulingPageState extends State<MonthlySchedulingPage> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPeriodSelector(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: 5,
              itemBuilder: (_, i) => _RoomCalendarCard(
                roomNumber: i + 1,
                month: _selectedMonth,
                year: _selectedYear,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          ),
        ),
      ),
      foregroundColor: Colors.white,
      title: Text(
        'Programmazione Mensile',
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final years = List.generate(6, (i) => DateTime.now().year - 1 + i);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month,
              color: Color(0xFF4F46E5), size: 20),
          const SizedBox(width: 10),
          Text(
            'Periodo:',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedMonth,
                isDense: true,
                items: [
                  for (int i = 0; i < 12; i++)
                    DropdownMenuItem(
                      value: i + 1,
                      child: Text(_kMonths[i],
                          style: GoogleFonts.inter(fontSize: 14)),
                    ),
                ],
                onChanged: (v) {
                  if (v != null && v != _selectedMonth) {
                    setState(() => _selectedMonth = v);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedYear,
              isDense: true,
              items: [
                for (final y in years)
                  DropdownMenuItem(
                    value: y,
                    child: Text('$y',
                        style: GoogleFonts.inter(fontSize: 14)),
                  ),
              ],
              onChanged: (v) {
                if (v != null && v != _selectedYear) {
                  setState(() => _selectedYear = v);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card calendario sala ──────────────────────────────────────────────────────

class _RoomCalendarCard extends StatelessWidget {
  const _RoomCalendarCard({
    required this.roomNumber,
    required this.month,
    required this.year,
  });

  final int roomNumber;
  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.meeting_room,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Sala $roomNumber',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // ── Griglia calendario ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: _CalendarGrid(month: month, year: year),
          ),
        ],
      ),
    );
  }
}

// ── Griglia del mese ──────────────────────────────────────────────────────────

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.month, required this.year});

  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Lun .. 7=Dom
    final leadingEmpty = firstWeekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        // ── Intestazione giorni ──────────────────────────────────────────
        Row(
          children: _kDayNames
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
        // ── Righe settimane ──────────────────────────────────────────────
        for (int row = 0; row < rows; row++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int col = 0; col < 7; col++)
                Expanded(
                  child: _DayCell(
                    day: row * 7 + col - leadingEmpty + 1,
                    valid: (row * 7 + col) >= leadingEmpty &&
                        (row * 7 + col - leadingEmpty + 1) <= daysInMonth,
                    isWeekend: col >= 5,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

// ── Cella giorno ─────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.valid,
    required this.isWeekend,
  });

  final int day;
  final bool valid;
  final bool isWeekend;

  @override
  Widget build(BuildContext context) {
    if (!valid) return const SizedBox(height: 60);

    return Container(
      height: 60,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isWeekend ? const Color(0xFFF1F5F9) : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          '$day',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isWeekend ? Colors.black38 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
