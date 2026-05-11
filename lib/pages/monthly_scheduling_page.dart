import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scheduled_block.dart';

// ── Costanti ──────────────────────────────────────────────────────────────────

const List<String> _kMonths = [
  'Gennaio', 'Febbraio', 'Marzo', 'Aprile',
  'Maggio', 'Giugno', 'Luglio', 'Agosto',
  'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
];

const List<String> _kDayNames = [
  'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom',
];

const Map<int, Color> _kDeptColors = {
  1: Color(0xFF15803D),
  2: Color(0xFF1E40AF),
  3: Color(0xFFBE185D),
  4: Color(0xFFD97706),
  5: Color(0xFF7C3AED),
  6: Color(0xFFDC2626),
  7: Color(0xFF0D9488),
};

const Map<int, String> _kDeptAbbr = {
  1: 'Chir. Gen.',
  2: 'Ortopedia',
  3: 'Ginecol.',
  4: 'Urologia',
  5: 'Neuro.',
  6: 'Cardio.',
  7: 'ORL',
};

// ── Pagina principale ────────────────────────────────────────────────────────

class MonthlySchedulingPage extends StatefulWidget {
  final int? initialMonth;
  final int? initialYear;

  const MonthlySchedulingPage({
    super.key,
    this.initialMonth,
    this.initialYear,
  });

  @override
  State<MonthlySchedulingPage> createState() =>
      _MonthlySchedulingPageState();
}

class _MonthlySchedulingPageState extends State<MonthlySchedulingPage> {
  late int _selectedMonth;
  late int _selectedYear;
  List<ScheduledBlock> _schedule = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth ?? DateTime.now().month;
    _selectedYear  = widget.initialYear  ?? DateTime.now().year;
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('schedule_${_selectedYear}_$_selectedMonth');
    if (raw != null) {
      _schedule = (jsonDecode(raw) as List)
          .map((e) => ScheduledBlock.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _schedule = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPeriodSelector(),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: 5,
                itemBuilder: (_, i) {
                  final roomId = i + 1;
                  final roomBlocks = _schedule
                      .where((b) => b.roomId == roomId)
                      .toList();
                  return _RoomCalendarCard(
                    roomNumber: roomId,
                    month: _selectedMonth,
                    year: _selectedYear,
                    blocks: roomBlocks,
                  );
                },
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
          Text('Periodo:',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 14)),
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
                    _loadSchedule();
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
                  _loadSchedule();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card sala operatoria ──────────────────────────────────────────────────────

class _RoomCalendarCard extends StatelessWidget {
  const _RoomCalendarCard({
    required this.roomNumber,
    required this.month,
    required this.year,
    required this.blocks,
  });

  final int roomNumber;
  final int month;
  final int year;
  final List<ScheduledBlock> blocks;

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
          // ── Header ────────────────────────────────────────────────────
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
                const Spacer(),
                if (blocks.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${blocks.length} interventi',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          // ── Griglia ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: _CalendarGrid(
              month: month,
              year: year,
              blocks: blocks,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Griglia mensile ───────────────────────────────────────────────────────────

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.year,
    required this.blocks,
  });

  final int month;
  final int year;
  final List<ScheduledBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Lun..7=Dom
    final leadingEmpty = firstWeekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        // Intestazione giorni della settimana
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
        // Righe settimane
        for (int row = 0; row < rows; row++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int col = 0; col < 7; col++)
                Expanded(
                  child: _buildCell(row, col, leadingEmpty, daysInMonth),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildCell(
      int row, int col, int leadingEmpty, int daysInMonth) {
    final cellIndex = row * 7 + col;
    final day = cellIndex - leadingEmpty + 1;
    final valid = cellIndex >= leadingEmpty && day <= daysInMonth;

    if (!valid) return const SizedBox(height: 64);

    final dayBlocks = blocks.where((b) => b.day == day).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    return _DayCell(
      day: day,
      isWeekend: col >= 5,
      blocks: dayBlocks,
    );
  }
}

// ── Cella giorno ─────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isWeekend,
    required this.blocks,
  });

  final int day;
  final bool isWeekend;
  final List<ScheduledBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isWeekend ? const Color(0xFFF1F5F9) : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numero del giorno
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 3, 4, 2),
            child: Text(
              '$day',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isWeekend ? Colors.black38 : Colors.black87,
              ),
            ),
          ),
          // Blocchi interventi
          if (blocks.isNotEmpty)
            ...blocks.map((b) => _InterventionChip(block: b)),
          // Altezza minima quando vuota
          if (blocks.isEmpty) const SizedBox(height: 44),
        ],
      ),
    );
  }
}

// ── Chip intervento nella cella ───────────────────────────────────────────────

class _InterventionChip extends StatelessWidget {
  const _InterventionChip({required this.block});

  final ScheduledBlock block;

  @override
  Widget build(BuildContext context) {
    final color = _kDeptColors[block.deptId] ?? Colors.grey;
    final abbr  = _kDeptAbbr[block.deptId]  ?? '?';

    return Container(
      margin: const EdgeInsets.fromLTRB(3, 0, 3, 3),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border(left: BorderSide(color: color, width: 3)),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            abbr,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            block.timeLabel,
            style: GoogleFonts.inter(
              fontSize: 8,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
