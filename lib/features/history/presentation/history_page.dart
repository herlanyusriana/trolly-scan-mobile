import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/layout_constants.dart';
import '../../home/presentation/cubit/departure_history_cubit.dart';
import '../../home/presentation/cubit/departure_history_state.dart';
import '../../scan/domain/entities/trolley_submission.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _sequenceController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _sequenceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? _startDate ?? _endDate ?? now
        : _endDate ?? _startDate ?? now;

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDate: initial,
    );

    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && picked.isAfter(_endDate!)) {
          _endDate = picked;
        }
      } else {
        _endDate = picked;
        if (_startDate != null && picked.isBefore(_startDate!)) {
          _startDate = picked;
        }
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _sequenceController.clear();
    });
  }

  List<TrolleySubmission> _applyFilters(List<TrolleySubmission> entries) {
    final sequenceInput = _sequenceController.text.trim();
    final sequenceNumber =
        sequenceInput.isEmpty ? null : int.tryParse(sequenceInput);

    final start = _startDate != null
        ? DateTime(_startDate!.year, _startDate!.month, _startDate!.day)
        : null;
    final end = _endDate != null
        ? DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            23,
            59,
            59,
            999,
          )
        : null;

    return entries.where((submission) {
      if (sequenceNumber != null &&
          submission.sequenceNumber != sequenceNumber) {
        return false;
      }
      final createdAt = submission.createdAt;
      if (start != null && createdAt.isBefore(start)) {
        return false;
      }
      if (end != null && createdAt.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'dd/mm/yyyy';
    return DateFormat('dd/MM/yyyy').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pergerakan Troli'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: LayoutConstants.pagePadding(
            context,
            horizontalScale: 0.85,
            verticalScale: 0.85,
          ),
          child: BlocBuilder<DepartureHistoryCubit, DepartureHistoryState>(
            builder: (context, state) {
              final filtered = _applyFilters(state.entries)
                ..sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Riwayat',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DateField(
                                label: 'Dari Tanggal',
                                value: _formatDate(_startDate),
                                onTap: () => _pickDate(isStart: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DateField(
                                label: 'Sampai Tanggal',
                                value: _formatDate(_endDate),
                                onTap: () => _pickDate(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _sequenceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nomor Urutan Keberangkatan',
                            hintText: 'Misal: 12',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => setState(() {}),
                                icon: const Icon(Icons.search_rounded),
                                label: const Text('Terapkan Filter'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _resetFilters,
                                child: const Text('Reset'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: filtered.isEmpty
                        ? _EmptyHistoryState(
                            hasFilters:
                                _sequenceController.text.isNotEmpty ||
                                    _startDate != null ||
                                    _endDate != null,
                          )
                        : ListView.separated(
                            itemBuilder: (_, index) => _HistorySubmissionTile(
                              submission: filtered[index],
                            ),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemCount: filtered.length,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: value == 'dd/mm/yyyy'
                          ? Colors.white54
                          : Colors.white,
                    ),
                  ),
                  const Icon(Icons.calendar_today_rounded, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState({required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasFilters ? Icons.search_off_rounded : Icons.content_paste_off,
            size: 40,
            color: Colors.white54,
          ),
          const SizedBox(height: 12),
          Text(
            hasFilters
                ? 'Tidak ada data sesuai filter.'
                : 'Belum ada riwayat keberangkatan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistorySubmissionTile extends StatelessWidget {
  const _HistorySubmissionTile({required this.submission});

  final TrolleySubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sequence = submission.sequenceNumber != null
        ? submission.sequenceNumber!.toString().padLeft(2, '0')
        : '--';
    final createdAt =
        DateFormat('dd MMM yyyy HH:mm').format(submission.createdAt.toLocal());
    final destination = submission.destination ?? '-';
    final firstReceipt =
        submission.receipts.isNotEmpty ? submission.receipts.first : null;
    String driver =
        submission.driverSnapshot ??
        firstReceipt?.driverSnapshot ??
        submission.driverId ??
        '-';
    if (driver.trim().isEmpty) driver = '-';
    String vehicle =
        submission.vehicleSnapshot ??
        firstReceipt?.vehicleSnapshot ??
        submission.vehicleId ??
        '-';
    if (vehicle.trim().isEmpty) vehicle = '-';
    final status = submission.status.toUpperCase();
    final trolleyCount = submission.trolleyCodes.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Text(
                  'Urutan #$sequence',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu Aktivitas',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      createdAt,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: status == 'OUT'
                      ? const Color.fromRGBO(59, 130, 246, 0.2)
                      : const Color.fromRGBO(34, 197, 94, 0.2),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: status == 'OUT'
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF22C55E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Tujuan / Lokasi', value: destination),
          const SizedBox(height: 10),
          _InfoRow(label: 'Driver', value: driver),
          const SizedBox(height: 10),
          _InfoRow(label: 'Kendaraan', value: vehicle),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Total Troli',
            value: '$trolleyCount unit',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
