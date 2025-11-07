import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_router.dart';
import 'bloc/scan_bloc.dart';
import 'bloc/scan_event.dart';
import 'bloc/scan_state.dart';
import 'scan_camera_page.dart';
import '../utils/trolley_code_parser.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Future<void> _openScanner(BuildContext context) async {
    final scannedCodes = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute<List<String>>(
        builder: (_) => const ScanCameraPage(),
        fullscreenDialog: true,
      ),
    );
    if (!context.mounted ||
        scannedCodes == null ||
        scannedCodes.isEmpty) {
      return;
    }

    final bloc = context.read<ScanBloc>();
    int addedCount = 0;
    for (final rawCode in scannedCodes) {
      final normalized = parseTrolleyCode(rawCode);
      if (normalized == null) continue;
      if (!bloc.state.scannedCodes.contains(normalized)) {
        bloc.add(ScanCodeAdded(normalized));
        addedCount++;
      }
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          addedCount > 0
              ? '$addedCount kode baru ditambahkan'
              : 'Semua kode sudah ada di daftar',
        ),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ScanBloc>().add(const ScanMastersRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Trolley'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Tambah manual',
            onPressed: () async {
              final code = await _showAddCodeDialog(context);
              if (!context.mounted) return;
              final normalized = parseTrolleyCode(code);
              if (normalized != null && normalized.isNotEmpty) {
                context.read<ScanBloc>().add(ScanCodeAdded(normalized));
              } else if (code != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kode troli tidak valid.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          final theme = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trolley scanned (${state.scannedCodes.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openScanner(context),
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Scan QR'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: state.scannedCodes.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada kode yang discan. Tekan tombol scan untuk memulai.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 88),
                            itemCount: state.scannedCodes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final code = state.scannedCodes[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xFF1E293B),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      code,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => context
                                          .read<ScanBloc>()
                                          .add(ScanCodeRemoved(code)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                if (state.status == ScanStatus.failure && state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        state.error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.scannedCodes.isEmpty
                            ? null
                            : () => context.read<ScanBloc>().add(
                                const ScanCleared(),
                              ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.scannedCodes.isEmpty
                            ? null
                            : () => Navigator.of(
                                context,
                              ).pushNamed(AppRouter.scanSummary),
                        child: const Text('Lanjutkan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> _showAddCodeDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Masukkan kode troli'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Misal: LORY-1010'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    return result;
  }
}
