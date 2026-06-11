import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Modello dati ──────────────────────────────────────────────────────────────

class _MonthStats {
  final int year;
  final int month;
  final int scheduledCount;
  final int totalCount;
  final int scheduledMinutes;
  final int availableMinutes;

  double get schedulingRate =>
      totalCount > 0 ? scheduledCount / totalCount * 100 : 0;
  double get utilization => scheduledMinutes / availableMinutes * 100;
  int get unscheduledCount => totalCount - scheduledCount;

  const _MonthStats({
    required this.year,
    required this.month,
    required this.scheduledCount,
    required this.totalCount,
    required this.scheduledMinutes,
    required this.availableMinutes,
  });
}

// ── Costanti ──────────────────────────────────────────────────────────────────

const _kMonths = [
  'Gennaio', 'Febbraio', 'Marzo', 'Aprile',
  'Maggio',  'Giugno',   'Luglio', 'Agosto',
  'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
];

// ── Pagina ────────────────────────────────────────────────────────────────────

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<_MonthStats> _stats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _compute();
  }

  void _compute() {
    final result = <_MonthStats>[];

    for (int year = 2026; year <= 2029; year++) {
      for (int month = 1; month <= 10; month++) {
        final schedRaw =
            html.window.localStorage['schedule_${year}_$month'];
        final unschedRaw =
            html.window.localStorage['unscheduled_${year}_$month'];

        if (schedRaw == null && unschedRaw == null) continue;

        final blocks =
            schedRaw != null ? jsonDecode(schedRaw) as List : [];
        final unscheduled =
            unschedRaw != null ? jsonDecode(unschedRaw) as List : [];

        int scheduledMinutes = 0;
        for (final b in blocks) {
          scheduledMinutes +=
              (b['endMinutes'] as int) - (b['startMinutes'] as int);
        }

        final daysInMonth = DateTime(year, month + 1, 0).day;

        result.add(_MonthStats(
          year: year,
          month: month,
          scheduledCount: blocks.length,
          totalCount: blocks.length + unscheduled.length,
          scheduledMinutes: scheduledMinutes,
          availableMinutes: 5 * daysInMonth * 840,
        ));
      }
    }

    setState(() {
      _stats = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _stats.isEmpty
              ? _buildEmpty()
              : _buildBody(),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() => AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        title: Text(
          'Statistiche Scheduling',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, color: Colors.white),
        ),
      );

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmpty() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bar_chart_outlined,
                size: 64, color: Colors.black26),
            const SizedBox(height: 16),
            Text(
              'Nessuna programmazione trovata.',
              style: GoogleFonts.inter(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Genera la programmazione per i mesi desiderati\n'
              'e poi torna qui.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black38, fontSize: 13),
            ),
          ],
        ),
      );

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    // Raggruppa per anno
    final byYear = <int, List<_MonthStats>>{};
    for (final s in _stats) {
      byYear.putIfAbsent(s.year, () => []).add(s);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 16),
        for (final year in byYear.keys.toList()..sort()) ...[
          _buildYearHeader(year, byYear[year]!),
          const SizedBox(height: 8),
          _buildYearTable(byYear[year]!),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  // ── Summary card ───────────────────────────────────────────────────────────

  Widget _buildSummaryCard() {
    final totalSched = _stats.fold(0, (s, m) => s + m.scheduledCount);
    final totalAll   = _stats.fold(0, (s, m) => s + m.totalCount);
    final totalSchedMin = _stats.fold(0, (s, m) => s + m.scheduledMinutes);
    final totalAvailMin = _stats.fold(0, (s, m) => s + m.availableMinutes);
    final overallRate  = totalAll > 0 ? totalSched / totalAll * 100 : 0.0;
    final overallUtil  = totalSchedMin / totalAvailMin * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x334F46E5), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Riepilogo totale — Gen 2026 → Ott 2029',
              style: GoogleFonts.inter(
                  color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  icon: Icons.check_circle_outline,
                  label: 'Tasso scheduling',
                  value: '${overallRate.toStringAsFixed(1)}%',
                  sub: '$totalSched / $totalAll interventi',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  icon: Icons.door_front_door_outlined,
                  label: 'Utilizzo sale',
                  value: '${overallUtil.toStringAsFixed(1)}%',
                  sub: '${_fmtHours(totalSchedMin)} / ${_fmtHours(totalAvailMin)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Mesi analizzati',
                  value: '${_stats.length}',
                  sub: '4 anni × fino a 10 mesi',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  icon: Icons.warning_amber_outlined,
                  label: 'Non schedulati',
                  value: '${totalAll - totalSched}',
                  sub: 'su $totalAll totali',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Year header ────────────────────────────────────────────────────────────

  Widget _buildYearHeader(int year, List<_MonthStats> months) {
    final totalSched = months.fold(0, (s, m) => s + m.scheduledCount);
    final totalAll   = months.fold(0, (s, m) => s + m.totalCount);
    final totalMin   = months.fold(0, (s, m) => s + m.scheduledMinutes);
    final availMin   = months.fold(0, (s, m) => s + m.availableMinutes);
    final rate = totalAll > 0 ? totalSched / totalAll * 100 : 0.0;
    final util = totalMin / availMin * 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(
            '$year',
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 12),
          _rateChip(rate),
          const SizedBox(width: 8),
          _utilChip(util),
          const Spacer(),
          Text(
            '$totalSched / $totalAll  •  ${_fmtHours(totalMin)}h sched.',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ── Year table ─────────────────────────────────────────────────────────────

  Widget _buildYearTable(List<_MonthStats> months) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.grey.shade100,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _colHeader('Mese', flex: 3),
                _colHeader('Sched. / Tot.', flex: 3, center: true),
                _colHeader('Tasso\nScheduling', flex: 3, center: true),
                _colHeader('Min. Sched. / Disp.', flex: 4, center: true),
                _colHeader('Utilizzo\nSale', flex: 3, center: true),
              ],
            ),
          ),
          const Divider(height: 1),
          // Rows
          for (int i = 0; i < months.length; i++) ...[
            _buildRow(months[i], i.isEven),
            if (i < months.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(_MonthStats s, bool even) {
    return Container(
      color: even ? Colors.white : Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Mese
          Expanded(
            flex: 3,
            child: Text(
              _kMonths[s.month - 1],
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          // Schedulati / Totali
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                '${s.scheduledCount} / ${s.totalCount}',
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          ),
          // Tasso scheduling
          Expanded(
            flex: 3,
            child: Center(child: _rateChip(s.schedulingRate)),
          ),
          // Minuti schedulati / disponibili
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                '${_fmtHours(s.scheduledMinutes)} / ${_fmtHours(s.availableMinutes)} h',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          // Utilizzo sale
          Expanded(
            flex: 3,
            child: Center(child: _utilChip(s.utilization)),
          ),
        ],
      ),
    );
  }

  // ── Helper widgets ─────────────────────────────────────────────────────────

  Widget _colHeader(String text, {int flex = 2, bool center = false}) =>
      Expanded(
        flex: flex,
        child: Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
      );

  Widget _rateChip(double rate) {
    final color = rate >= 95
        ? const Color(0xFF15803D)
        : rate >= 80
            ? const Color(0xFF16A34A)
            : rate >= 60
                ? const Color(0xFFD97706)
                : const Color(0xFFDC2626);
    return _Chip(label: '${rate.toStringAsFixed(1)}%', color: color);
  }

  Widget _utilChip(double util) {
    final color = util >= 60
        ? const Color(0xFF15803D)
        : util >= 40
            ? const Color(0xFFD97706)
            : const Color(0xFFDC2626);
    return _Chip(label: '${util.toStringAsFixed(1)}%', color: color);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _fmtHours(int minutes) =>
      (minutes / 60).toStringAsFixed(0);
}

// ── Chip colorato ─────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color),
      ),
    );
  }
}

// ── Tile riepilogo ────────────────────────────────────────────────────────────

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });
  final IconData icon;
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              Text(sub,
                  style: GoogleFonts.inter(
                      color: Colors.white60, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
