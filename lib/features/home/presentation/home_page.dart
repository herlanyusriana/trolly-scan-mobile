import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_router.dart';
import '../../../core/theme/layout_constants.dart';
import '../../../core/storage/session_storage.dart';
import '../../auth/domain/entities/mobile_user.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../../scan/domain/entities/movement_receipt.dart';
import '../../scan/domain/entities/trolley_submission.dart';
import '../../scan/domain/repositories/trolley_repository.dart';
import 'cubit/departure_history_cubit.dart';
import 'cubit/departure_history_state.dart';
import 'cubit/trolley_summary_cubit.dart';
import 'cubit/trolley_summary_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrolleySummaryCubit>(
          create: (context) =>
              TrolleySummaryCubit(context.read<TrolleyRepository>())
                ..loadSummary(),
        ),
        BlocProvider<DepartureHistoryCubit>(
          create: (context) =>
              DepartureHistoryCubit(context.read<SessionStorage>())
                ..loadHistory(),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/logo_gci.png',
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              const Text('Geum Cheon Trolly'),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Perbarui data',
              onPressed: () {
                context.read<TrolleySummaryCubit>().loadSummary();
                context.read<DepartureHistoryCubit>().loadHistory();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final user = authState.user;
            final displayName = _resolveDisplayName(user);
            final shiftLabel = _resolveShiftLabel(user);

            return RefreshIndicator(
              onRefresh: () async {
                final summaryCubit = context.read<TrolleySummaryCubit>();
                final historyCubit = context.read<DepartureHistoryCubit>();
                await summaryCubit.loadSummary();
                historyCubit.loadHistory();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: LayoutConstants.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $displayName',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shiftLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRouter.scan),
                              icon: const Icon(Icons.qr_code_scanner_rounded),
                              label: const Text('Scan Trolley'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed(
                                AppRouter.history,
                              ),
                              icon: const Icon(Icons.history_rounded),
                              label: const Text('History'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Ringkasan Troli',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _TrolleySummarySection(),
                      const SizedBox(height: 32),
                      Text(
                        'Urutan Keberangkatan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _DepartureTimelineSection(),
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Surat jalan akan tersedia setelah submit',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static String _resolveDisplayName(MobileUser? user) {
    final name = user?.name.trim();
    if (name != null && name.isNotEmpty) return name;
    final phone = user?.phone?.trim();
    if (phone != null && phone.isNotEmpty) return phone;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    return 'Operator';
  }

  static String _resolveShiftLabel(MobileUser? user) {
    final shift = user?.shift?.trim();
    if (shift != null && shift.isNotEmpty) {
      return 'Shift Aktif: $shift';
    }

    final now = DateTime.now().hour;
    if (now >= 6 && now < 14) {
      return 'Shift Aktif: Pagi (06:00 - 14:00)';
    }
    if (now >= 14 && now < 22) {
      return 'Shift Aktif: Sore (14:00 - 22:00)';
    }
    return 'Shift Aktif: Malam (22:00 - 06:00)';
  }
}

class _TrolleySummarySection extends StatelessWidget {
  const _TrolleySummarySection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrolleySummaryCubit, TrolleySummaryState>(
      builder: (context, state) {
        if (state.status == TrolleySummaryStatus.loading) {
          return const _SummaryLoading();
        }

        if (state.status == TrolleySummaryStatus.failure) {
          return _SummaryError(message: state.error ?? 'Gagal memuat data');
        }

        if (state.summaries.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text('Belum ada data troli yang tersedia.'),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth >= 1100) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth >= 720) {
              crossAxisCount = 2;
            }
            final summaries = state.summaries;
            return GridView.builder(
              shrinkWrap: true,
              itemCount: summaries.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 2.2 : 1.8,
              ),
              itemBuilder: (_, index) =>
                  _TrolleyKindCard(summary: summaries[index]),
            );
          },
        );
      },
    );
  }
}

class _TrolleyKindCard extends StatelessWidget {
  const _TrolleyKindCard({required this.summary});

  final TrolleyKindSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.15,
                ),
                child: Text(
                  summary.displayName.isNotEmpty
                      ? summary.displayName[0].toUpperCase()
                      : '?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                summary.displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${summary.total} troli',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryChip(
                label: 'Di Lokasi',
                value: summary.insideCount,
                color: const Color(0xFF22C55E),
              ),
              _SummaryChip(
                label: 'Di Luar Lokasi',
                value: summary.outsideCount,
                color: const Color(0xFFF97316),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Saat ini terdapat ${summary.insideCount} troli di lokasi dan ${summary.outsideCount} troli berada di luar lokasi.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '$value troli',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLoading extends StatelessWidget {
  const _SummaryLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
        childAspectRatio: 2.0,
      ),
      itemCount: 1,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(20),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Text(message, style: const TextStyle(color: Colors.redAccent)),
    );
  }
}

class _DepartureTimelineSection extends StatelessWidget {
  const _DepartureTimelineSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartureHistoryCubit, DepartureHistoryState>(
      builder: (context, state) {
        if (state.entries.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Belum ada riwayat keberangkatan. Data akan muncul setelah Anda mengirim submit scan.',
            ),
          );
        }

        final items = state.entries.take(5).toList();
        return Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              _DepartureCard(submission: items[i], position: i + 1),
              if (i != items.length - 1) const SizedBox(height: 14),
            ],
          ],
        );
      },
    );
  }
}

class _DepartureCard extends StatelessWidget {
  const _DepartureCard({required this.submission, required this.position});

  final TrolleySubmission submission;
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sequence = submission.sequenceNumber != null
        ? submission.sequenceNumber!.toString().padLeft(2, '0')
        : '--';
    String driver =
        submission.driverSnapshot ??
        submission.receipts.firstOrNull?.driverSnapshot ??
        submission.driverId ??
        '-';
    if (driver.trim().isEmpty) driver = '-';

    String vehicle =
        submission.vehicleSnapshot ??
        submission.receipts.firstOrNull?.vehicleSnapshot ??
        submission.vehicleId ??
        '-';
    if (vehicle.trim().isEmpty) vehicle = '-';
    final createdAt = DateFormat(
      'dd MMM yyyy HH:mm',
    ).format(submission.createdAt.toLocal());
    final destination = submission.destination ?? '-';
    final receipts = submission.receipts;
    final displayReceipts = receipts.isNotEmpty
        ? receipts
        : submission.trolleyCodes
              .map(
                (code) =>
                    MovementReceipt(code: code, status: submission.status),
              )
              .toList();
    final previewReceipts = displayReceipts.take(4).toList();
    final remaining = displayReceipts.length - previewReceipts.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '#${position.toString().padLeft(2, '0')}',
                  style: theme.textTheme.titleSmall?.copyWith(
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
              Chip(
                label: Text('Urutan $sequence'),
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _HistoryInfoRow(label: 'Plat Mobil', value: vehicle),
          const SizedBox(height: 6),
          _HistoryInfoRow(label: 'Driver', value: driver),
          const SizedBox(height: 6),
          _HistoryInfoRow(label: 'Lokasi / Tujuan', value: destination),
          const SizedBox(height: 6),
          _HistoryInfoRow(
            label: 'Jumlah Troli',
            value: '${submission.trolleyCodes.length} unit',
          ),
          const SizedBox(height: 12),
          Text(
            'List Troli',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          ...previewReceipts.map(
            (receipt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${receipt.code} • ${receipt.trolleyKind ?? 'Tidak diketahui'}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (remaining > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+$remaining troli lainnya',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryInfoRow extends StatelessWidget {
  const _HistoryInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

extension on List<MovementReceipt> {
  MovementReceipt? get firstOrNull => isNotEmpty ? first : null;
}
