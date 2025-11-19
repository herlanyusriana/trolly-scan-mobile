import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_router.dart';
import 'bloc/scan_bloc.dart';
import 'bloc/scan_event.dart';
import 'bloc/scan_state.dart';
import 'submission_summary_page.dart';

const _noneVehicleValue = '__none_vehicle__';
const _manualVehicleValue = '__manual_vehicle__';
const _noneDriverValue = '__none_driver__';
const _manualDriverValue = '__manual_driver__';

class ScanSummaryPage extends StatefulWidget {
  const ScanSummaryPage({super.key});

  @override
  State<ScanSummaryPage> createState() => _ScanSummaryPageState();
}

class _ScanSummaryPageState extends State<ScanSummaryPage> {
  final _vehicleManualController = TextEditingController();
  final _driverManualController = TextEditingController();

  String _selectedVehicleValue = _noneVehicleValue;
  String _selectedDriverValue = _noneDriverValue;
  String _status = 'out';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanBloc>().add(const ScanMastersRequested());
    });
  }

  @override
  void dispose() {
    _vehicleManualController.dispose();
    _driverManualController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, ScanState state) {
    final departureNumber = state.departureNumber;
    if (departureNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih nomor keberangkatan terlebih dahulu.'),
        ),
      );
      return;
    }

    final destination = _status == 'in' ? 'GCI' : 'LG';

    String? vehicleId;
    String? vehicleSnapshot;
    if (_selectedVehicleValue == _manualVehicleValue) {
      vehicleSnapshot = _vehicleManualController.text.trim().toUpperCase();
      if (_status == 'out' && vehicleSnapshot.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Isi plat kendaraan secara manual atau pilih dari daftar.',
            ),
          ),
        );
        return;
      }
    } else if (_selectedVehicleValue != _noneVehicleValue) {
      vehicleId = _selectedVehicleValue;
    }

    String? driverId;
    String? driverSnapshot;
    if (_selectedDriverValue == _manualDriverValue) {
      driverSnapshot = _driverManualController.text.trim();
      if (_status == 'out' && driverSnapshot.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Isi nama driver secara manual atau pilih dari daftar.',
            ),
          ),
        );
        return;
      }
    } else if (_selectedDriverValue != _noneDriverValue) {
      driverId = _selectedDriverValue;
    }

    if (_status == 'out' &&
        driverId == null &&
        (driverSnapshot == null || driverSnapshot.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Driver wajib dipilih atau diisi untuk status OUT.'),
        ),
      );
      return;
    }

    context.read<ScanBloc>().add(
      ScanSubmitted(
        destination: destination,
        vehicleId: vehicleId,
        driverId: driverId,
        vehicleSnapshot: vehicleSnapshot?.isNotEmpty == true
            ? vehicleSnapshot
            : null,
        driverSnapshot: driverSnapshot?.isNotEmpty == true
            ? driverSnapshot
            : null,
        status: _status,
        departureNumber: departureNumber,
      ),
    );
  }

  void _changeStatus(String newStatus) {
    if (_status == newStatus) return;
    setState(() {
      _status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state.status == ScanStatus.success &&
            state.lastSubmission != null) {
          final submission = state.lastSubmission!;
          context.read<ScanBloc>().add(const ScanCleared());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => SubmissionSummaryPage(submission: submission),
            ),
            ModalRoute.withName(AppRouter.home),
          );
        } else if (state.status == ScanStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error ?? 'Gagal mengirim data, disimpan offline.',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final scannedCodes = state.scannedCodes;
        final isSubmitting = state.status == ScanStatus.submitting;
        final isMastersLoading = state.mastersStatus == MasterStatus.loading;
        final hasMastersError = state.mastersStatus == MasterStatus.failure;
        final departureNumber = state.departureNumber;
        final departureLabel = departureNumber != null
            ? departureNumber.toString().padLeft(2, '0')
            : '-';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Konfirmasi Scan'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMastersLoading)
                  const LinearProgressIndicator(minHeight: 3),
                if (hasMastersError && state.mastersError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      'Gagal memuat master data: ${state.mastersError}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                _SummaryCard(
                  title: 'Items Scanned',
                  child: scannedCodes.isEmpty
                      ? const Text(
                          'Belum ada data troli. Kembali dan scan ulang.',
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: scannedCodes
                              .map(
                                (code) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text('- $code'),
                                ),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 16),
                _SummaryCard(
                  title: 'Informasi Operasional',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'Nomor Keberangkatan: $departureLabel',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _status == 'out'
                                  ? 'Tujuan Keberangkatan'
                                  : 'Lokasi Pengembalian',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              _status == 'out' ? 'LG' : 'GCI',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedVehicleValue,
                        decoration: const InputDecoration(
                          labelText: 'Kendaraan',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: _noneVehicleValue,
                            child: Text('Pilih kendaraan (opsional)'),
                          ),
                          const DropdownMenuItem(
                            value: _manualVehicleValue,
                            child: Text('Masukkan manual'),
                          ),
                          ...state.vehicles.map(
                            (vehicle) => DropdownMenuItem(
                              value: vehicle.id,
                              child: Text(
                                [
                                  vehicle.plateNumber,
                                  if (vehicle.name != null &&
                                      vehicle.name!.isNotEmpty)
                                    '(${vehicle.name})',
                                ].join(' '),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleValue = value ?? _noneVehicleValue;
                          });
                        },
                      ),
                      if (_selectedVehicleValue == _manualVehicleValue)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextField(
                            controller: _vehicleManualController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              labelText: 'Plat kendaraan (manual)',
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDriverValue,
                        decoration: const InputDecoration(labelText: 'Driver'),
                        items: [
                          const DropdownMenuItem(
                            value: _noneDriverValue,
                            child: Text('Pilih driver (opsional)'),
                          ),
                          const DropdownMenuItem(
                            value: _manualDriverValue,
                            child: Text('Masukkan manual'),
                          ),
                          ...state.drivers.map(
                            (driver) => DropdownMenuItem(
                              value: driver.id,
                              child: Text(driver.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDriverValue = value ?? _noneDriverValue;
                          });
                        },
                      ),
                      if (_selectedDriverValue == _manualDriverValue)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextField(
                            controller: _driverManualController,
                            decoration: const InputDecoration(
                              labelText: 'Nama driver (manual)',
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('OUT'),
                            selected: _status == 'out',
                            onSelected: (value) {
                              if (value) _changeStatus('out');
                            },
                          ),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: const Text('IN'),
                            selected: _status == 'in',
                            onSelected: (value) {
                              if (value) _changeStatus('in');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (state.status == ScanStatus.failure && state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: scannedCodes.isEmpty || isSubmitting
                      ? null
                      : () => _submit(context, state),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kirim & Buat Surat Jalan'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
