import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/config/app_router.dart';
import '../domain/entities/movement_receipt.dart';
import '../domain/entities/trolley_submission.dart';

class SubmissionSummaryPage extends StatelessWidget {
  const SubmissionSummaryPage({super.key, required this.submission});

  final TrolleySubmission submission;

  static String _formatSequence(int? sequence) {
    if (sequence == null) return '-';
    return sequence.toString().padLeft(2, '0');
  }

  static String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd MMM yyyy HH:mm').format(value.toLocal());
  }

  Future<void> _exportSubmissionPdf(
    BuildContext context,
    List<MovementReceipt> receipts,
  ) async {
    if (receipts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data troli untuk dicetak.')),
      );
      return;
    }

    final doc = pw.Document();
    final driver =
        submission.driverSnapshot ??
        receipts.first.driverSnapshot ??
        submission.driverId ??
        '-';
    final vehicle =
        submission.vehicleSnapshot ??
        receipts.first.vehicleSnapshot ??
        submission.vehicleId ??
        '-';

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        pageFormat: pdf.PdfPageFormat.a4,
        build: (context) {
          final createdAt = _formatDateTime(submission.createdAt);
          final destination =
              submission.destination ?? receipts.first.destination ?? '-';
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'PT Geum Cheon Indo',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Departemen Operasional & Logistik',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'SURAT JALAN TROLI',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(createdAt, style: const pw.TextStyle(fontSize: 11)),
                ],
              ),
            ),
            _buildPdfRow(
              'Nomor Urut',
              _formatSequence(submission.sequenceNumber),
            ),
            _buildPdfRow('Tujuan / Lokasi', destination),
            _buildPdfRow('Driver', driver),
            _buildPdfRow('Kendaraan', vehicle),
            _buildPdfRow('Jumlah Troli', receipts.length.toString()),
            pw.SizedBox(height: 24),
            _buildCombinedTable(receipts, destination),
            pw.SizedBox(height: 32),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _signatureBlock('Yang Menerima'),
                _signatureBlock('Yang Menyerahkan'),
              ],
            ),
          ];
        },
      ),
    );

    try {
      final filename =
          'surat-jalan-${_formatSequence(submission.sequenceNumber)}.pdf';
      await Printing.sharePdf(bytes: await doc.save(), filename: filename);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuat PDF: $error')));
    }
  }

  static pw.Widget _buildCombinedTable(
    List<MovementReceipt> receipts,
    String fallbackDestination,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: pdf.PdfColors.grey600, width: 0.7),
      columnWidths: {
        0: const pw.FixedColumnWidth(36),
        1: const pw.FixedColumnWidth(80),
        2: const pw.FixedColumnWidth(90),
        3: const pw.FixedColumnWidth(70),
        4: const pw.FlexColumnWidth(),
        5: const pw.FixedColumnWidth(120),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: pdf.PdfColors.grey200),
          children: [
            _tableHeaderCell('No.'),
            _tableHeaderCell('Kode'),
            _tableHeaderCell('Jenis'),
            _tableHeaderCell('Status'),
            _tableHeaderCell('Tujuan / Lokasi'),
            _tableHeaderCell('Waktu'),
          ],
        ),
        ...receipts.map((receipt) {
          final times = [
            'Keluar: ${_formatDateTime(receipt.checkedOutAt)}',
            'Masuk: ${_formatDateTime(receipt.checkedInAt)}',
          ].join('\n');
          return pw.TableRow(
            children: [
              _tableCell(_formatSequence(receipt.sequenceNumber)),
              _tableCell(receipt.code),
              _tableCell(receipt.trolleyKind ?? '-'),
              _tableCell(receipt.status.toUpperCase()),
              _tableCell(receipt.destination ?? fallbackDestination),
              _tableCell(times),
            ],
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receipts = submission.receipts;
    final sequenceLabel = _formatSequence(submission.sequenceNumber);
    final printableReceipts = receipts.isNotEmpty
        ? receipts
        : submission.trolleyCodes
              .map(
                (code) => MovementReceipt(
                  code: code,
                  status: submission.status,
                  destination: submission.destination,
                ),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Pengiriman'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.flag_circle_outlined,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Urutan Keberangkatan #$sequenceLabel',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Data berhasil dikirim dan siap untuk dicetak.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _InfoGrid(submission: submission),
              const SizedBox(height: 24),
              Text(
                'Detail Troli',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: receipts.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada detail troli yang diterima dari server.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemCount: receipts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final receipt = receipts[index];
                          return _ReceiptCard(receipt: receipt);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _exportSubmissionPdf(context, printableReceipts),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text('Cetak Surat Jalan Urutan $sequenceLabel'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Kembali ke Beranda'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRouter.history);
                  },
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('Lihat Riwayat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 160,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

pw.Widget _tableHeaderCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
    ),
  );
}

pw.Widget _tableCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
  );
}

pw.Widget _signatureBlock(String title) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title, style: const pw.TextStyle(fontSize: 11)),
      pw.SizedBox(height: 48),
      pw.Container(
        width: 160,
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(color: pdf.PdfColors.grey700, width: 0.6),
          ),
        ),
      ),
    ],
  );
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.submission});

  final TrolleySubmission submission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receipts = submission.receipts;
    final firstReceipt = receipts.isNotEmpty ? receipts.first : null;

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C34),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: 'Total Troli',
            value: submission.trolleyCodes.length.toString(),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Nomor Keberangkatan',
            value: SubmissionSummaryPage._formatSequence(
              submission.sequenceNumber,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Tujuan / Lokasi',
            value: submission.destination ?? '-',
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Driver', value: driver),
          const SizedBox(height: 10),
          _InfoRow(label: 'Kendaraan', value: vehicle),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Waktu Submit',
            value: SubmissionSummaryPage._formatDateTime(submission.createdAt),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final MovementReceipt receipt;

  Color _statusColor(BuildContext context) {
    switch (receipt.status.toLowerCase()) {
      case 'out':
        return const Color(0xFFFB7185);
      case 'in':
        return const Color(0xFF4ADE80);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = receipt.status.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receipt.code,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(context).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _statusColor(context)),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _statusColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Nomor Urut',
            value: SubmissionSummaryPage._formatSequence(
              receipt.sequenceNumber,
            ),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Waktu Keluar',
            value: SubmissionSummaryPage._formatDateTime(receipt.checkedOutAt),
          ),
          if (receipt.checkedInAt != null) ...[
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Waktu Masuk',
              value: SubmissionSummaryPage._formatDateTime(receipt.checkedInAt),
            ),
          ],
          if ((receipt.destination ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Tujuan / Lokasi',
              value: receipt.destination ?? '-',
            ),
          ],
          if ((receipt.driverSnapshot ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(label: 'Driver', value: receipt.driverSnapshot ?? '-'),
          ],
          if ((receipt.vehicleSnapshot ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(label: 'Kendaraan', value: receipt.vehicleSnapshot ?? '-'),
          ],
        ],
      ),
    );
  }
}
