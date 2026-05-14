import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/intervention.dart';
import '../services/scheduler.dart';

// ── Costanti ospedale ────────────────────────────────────────────────────────

const List<String> _kRooms = [
  'Sala 1',
  'Sala 2',
  'Sala 3',
  'Sala 4',
  'Sala 5',
];

const List<_DeptInfo> _kDepartments = [
  _DeptInfo(id: 1, name: 'Chirurgia Generale',        color: Color(0xFF15803D), icon: Icons.medical_services),
  _DeptInfo(id: 2, name: 'Ortopedia e Traumatologia', color: Color(0xFF1E40AF), icon: Icons.accessibility_new),
  _DeptInfo(id: 3, name: 'Ginecologia',               color: Color(0xFFBE185D), icon: Icons.female),
  _DeptInfo(id: 4, name: 'Urologia',                  color: Color(0xFFD97706), icon: Icons.water_drop),
  _DeptInfo(id: 5, name: 'Neurochirurgia',            color: Color(0xFF7C3AED), icon: Icons.psychology),
  _DeptInfo(id: 6, name: 'Cardiochirurgia',           color: Color(0xFFDC2626), icon: Icons.favorite),
  _DeptInfo(id: 7, name: 'Otorinolaringoiatria',      color: Color(0xFF0D9488), icon: Icons.hearing),
];

const List<String> _kMonths = [
  'Gennaio', 'Febbraio', 'Marzo', 'Aprile',
  'Maggio', 'Giugno', 'Luglio', 'Agosto',
  'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
];

class _DeptInfo {
  final int id;
  final String name;
  final Color color;
  final IconData icon;
  const _DeptInfo({required this.id, required this.name, required this.color, required this.icon});
}

// ── Pagina principale ────────────────────────────────────────────────────────

class InterventionInsertionPage extends StatefulWidget {
  const InterventionInsertionPage({super.key});

  @override
  State<InterventionInsertionPage> createState() =>
      _InterventionInsertionPageState();
}

class _InterventionInsertionPageState
    extends State<InterventionInsertionPage> {
  final Map<int, List<Intervention>> _interventions = {
    for (final d in _kDepartments) d.id: [],
  };
  bool _loading = true;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  String _storageKey(int deptId) =>
      'dept_interventions_${_selectedYear}_${_selectedMonth}_$deptId';

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    for (final dept in _kDepartments) {
      final raw = prefs.getString(_storageKey(dept.id));
      if (raw != null) {
        final list = (jsonDecode(raw) as List)
            .map((e) => Intervention.fromJson(e as Map<String, dynamic>))
            .toList();
        _interventions[dept.id] = list;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _reloadForPeriod() async {
    for (final d in _kDepartments) {
      _interventions[d.id] = [];
    }
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    for (final dept in _kDepartments) {
      final raw = prefs.getString(_storageKey(dept.id));
      if (raw != null) {
        final list = (jsonDecode(raw) as List)
            .map((e) => Intervention.fromJson(e as Map<String, dynamic>))
            .toList();
        _interventions[dept.id] = list;
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveToStorage(int deptId) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _interventions[deptId]!.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_storageKey(deptId), encoded);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPeriodSelector(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              itemCount: _kDepartments.length,
              itemBuilder: (_, i) {
                final dept = _kDepartments[i];
                return _DepartmentCard(
                  dept: dept,
                  interventions: _interventions[dept.id]!,
                  onAdd: () => _openAddDialog(dept),
                  onDelete: (idx) {
                    setState(() => _interventions[dept.id]!.removeAt(idx));
                    _saveToStorage(dept.id);
                  },
                );
              },
            ),
          ),
          _buildGeneraButton(),
        ],
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
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Color(0xFF4F46E5), size: 20),
          const SizedBox(width: 10),
          Text(
            'Periodo:',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
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
                      child: Text(
                        _kMonths[i],
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                ],
                onChanged: (v) {
                  if (v != null && v != _selectedMonth) {
                    setState(() => _selectedMonth = v);
                    _reloadForPeriod();
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
                    child: Text('$y', style: GoogleFonts.inter(fontSize: 14)),
                  ),
              ],
              onChanged: (v) {
                if (v != null && v != _selectedYear) {
                  setState(() => _selectedYear = v);
                  _reloadForPeriod();
                }
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
        'Inserimento Interventi',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ── Bottone genera programmazione ────────────────────────────────────────

  Widget _buildGeneraButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FB),
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: FilledButton.icon(
          onPressed: _handleGeneraPressed,
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: Text(
            'Genera Programmazione',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGeneraPressed() async {
    final hasAny = _interventions.values.any((l) => l.isNotEmpty);
    if (!hasAny) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nessun intervento inserito per questo mese'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    final result = generateSchedule(_selectedYear, _selectedMonth, _interventions);
    final total = _interventions.values.fold(0, (s, l) => s + l.length);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'schedule_${_selectedYear}_$_selectedMonth',
      jsonEncode(result.scheduled.map((b) => b.toJson()).toList()),
    );
    await prefs.setString(
      'unscheduled_${_selectedYear}_$_selectedMonth',
      jsonEncode(result.unscheduled.map((u) => u.toJson()).toList()),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '${result.scheduled.length} di $total interventi programmati per '
        '${_kMonths[_selectedMonth - 1]} $_selectedYear',
      ),
      behavior: SnackBarBehavior.floating,
    ));

    await Navigator.pushNamed(
      context,
      '/scheduling',
      arguments: {'month': _selectedMonth, 'year': _selectedYear},
    );
  }

  // ── Dialogo "Aggiungi intervento" ─────────────────────────────────────────

  Future<void> _openAddDialog(_DeptInfo dept) async {
    final nameCtrl = TextEditingController();
    int hours = 0;
    int minutes = 30;
    final Set<int> selectedRooms = {};
    bool showErrors = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: EdgeInsets.zero,
          title: _DialogTitle(dept: dept),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Nome intervento ───────────────────────────────────────
                _sectionLabel('Nome intervento'),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  onChanged: (_) { if (showErrors) setLocal(() {}); },
                  decoration: _inputDeco('es. Appendicectomia laparoscopica')
                      .copyWith(
                    errorText: showErrors && nameCtrl.text.trim().isEmpty
                        ? "Inserisci il nome dell'intervento"
                        : null,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(80),
                  ],
                ),

                const SizedBox(height: 18),

                // ── Durata ────────────────────────────────────────────────
                _sectionLabel('Durata'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ore',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: Colors.black54)),
                          const SizedBox(height: 4),
                          _DurationDropdown(
                            value: hours,
                            items: List.generate(15, (i) => i),
                            label: (v) => '$v h',
                            onChanged: (v) => setLocal(() => hours = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Minuti',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: Colors.black54)),
                          const SizedBox(height: 4),
                          _DurationDropdown(
                            value: minutes,
                            items: [
                              0, 5, 10, 15, 20, 25, 30,
                              35, 40, 45, 50, 55,
                            ],
                            label: (v) => '$v min',
                            onChanged: (v) => setLocal(() => minutes = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showErrors && hours == 0 && minutes == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'La durata deve essere almeno 5 minuti',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: Colors.red.shade700),
                    ),
                  ),

                const SizedBox(height: 18),

                // ── Sale operatorie compatibili ───────────────────────────
                _sectionLabel('Sale operatorie compatibili'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (int i = 0; i < _kRooms.length; i++)
                      FilterChip(
                        label: Text(_kRooms[i],
                            style: GoogleFonts.inter(fontSize: 13)),
                        selected: selectedRooms.contains(i + 1),
                        selectedColor: dept.color.withValues(alpha: 0.18),
                        checkmarkColor: dept.color,
                        side: BorderSide(
                          color: selectedRooms.contains(i + 1)
                              ? dept.color
                              : Colors.black26,
                        ),
                        onSelected: (sel) => setLocal(() {
                          if (sel) {
                            selectedRooms.add(i + 1);
                          } else {
                            selectedRooms.remove(i + 1);
                          }
                        }),
                      ),
                  ],
                ),
                if (showErrors && selectedRooms.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Seleziona almeno una sala',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: Colors.red.shade700),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Annulla',
                  style: GoogleFonts.inter(color: Colors.black54)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FilledButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final durationOk = hours > 0 || minutes > 0;

                  if (name.isEmpty || !durationOk || selectedRooms.isEmpty) {
                    setLocal(() => showErrors = true);
                    return;
                  }

                  final intervention = Intervention(
                    name: name,
                    hours: hours,
                    minutes: minutes,
                    compatibleRoomIds: selectedRooms.toList()..sort(),
                  );
                  Navigator.pop(ctx);
                  setState(() => _interventions[dept.id]!.add(intervention));
                  _saveToStorage(dept.id);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Aggiungi intervento',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
  }
}

// ── Department card ───────────────────────────────────────────────────────────

class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({
    required this.dept,
    required this.interventions,
    required this.onAdd,
    required this.onDelete,
  });

  final _DeptInfo dept;
  final List<Intervention> interventions;
  final VoidCallback onAdd;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header colorato ──────────────────────────────────────────────
          Container(
            color: dept.color,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(dept.icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  dept.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                _HeaderBadge(label: '${interventions.length} interventi'),
                if (interventions.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _HeaderBadge(
                    label: 'media ${_avgDurationLabel(interventions)}',
                  ),
                ],
              ],
            ),
          ),

          // ── Lista interventi ─────────────────────────────────────────────
          if (interventions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Text(
                'Nessun intervento aggiunto',
                style: GoogleFonts.inter(
                    color: Colors.black38, fontSize: 13),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  for (int i = 0; i < interventions.length; i++)
                    _InterventionTile(
                      intervention: interventions[i],
                      deptColor: dept.color,
                      onDelete: () => onDelete(i),
                    ),
                ],
              ),
            ),

          // ── Pulsante aggiungi ────────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add, color: dept.color, size: 20),
              label: Text(
                'Aggiungi intervento',
                style: GoogleFonts.inter(
                    color: dept.color, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: dept.color),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge header reparto ──────────────────────────────────────────────────────

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

String _avgDurationLabel(List<Intervention> interventions) {
  final avgMin =
      interventions.fold(0, (sum, i) => sum + i.totalMinutes) ~/
      interventions.length;
  final h = avgMin ~/ 60;
  final m = avgMin % 60;
  if (h > 0 && m > 0) return '${h}h ${m}min';
  if (h > 0) return '${h}h';
  return '${m}min';
}

// ── Singola riga intervento ───────────────────────────────────────────────────

class _InterventionTile extends StatelessWidget {
  const _InterventionTile({
    required this.intervention,
    required this.deptColor,
    required this.onDelete,
  });

  final Intervention intervention;
  final Color deptColor;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: deptColor.withValues(alpha: 0.06),
        border: Border.all(color: deptColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intervention.name,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // durata
                    _InfoChip(
                      icon: Icons.schedule,
                      label: intervention.durationLabel,
                      color: deptColor,
                    ),
                    const SizedBox(width: 6),
                    // sale
                    Flexible(
                      child: Wrap(
                        spacing: 4,
                        children: [
                          for (final id in intervention.compatibleRoomIds)
                            _InfoChip(
                              icon: Icons.door_front_door_outlined,
                              label: 'S$id',
                              color: deptColor,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade400,
            tooltip: 'Elimina',
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}

// ── Titolo dialog con header colorato ─────────────────────────────────────────

class _DialogTitle extends StatelessWidget {
  const _DialogTitle({required this.dept});

  final _DeptInfo dept;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dept.color,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          const Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuovo intervento',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                Text(
                  dept.name,
                  style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dropdown durata ───────────────────────────────────────────────────────────

class _DurationDropdown extends StatelessWidget {
  const _DurationDropdown({
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  });

  final int value;
  final List<int> items;
  final String Function(int) label;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      items: [
        for (final v in items)
          DropdownMenuItem(value: v, child: Text(label(v))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _sectionLabel(String text) => Text(
      text,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
    );

InputDecoration _inputDeco(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.black38, fontSize: 13),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
