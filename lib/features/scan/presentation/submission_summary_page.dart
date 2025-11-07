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

  Future<void> _exportPdf(
    BuildContext context,
    MovementReceipt receipt,
  ) async {
    final doc = pw.Document();
    final createdAt = receipt.checkedOutAt ?? submission.createdAt;

    doc.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          final formattedCreatedAt =
              DateFormat('dd MMM yyyy HH:mm').format(submission.createdAt.toLocal());

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
                    pw.Text(
                      formattedCreatedAt,
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              _buildPdfRow('Nomor Urut', _formatSequence(receipt.sequenceNumber)),
              _buildPdfRow('Kode Troli', receipt.code),
              _buildPdfRow('Jenis Troli', submission.status.toUpperCase()),
              _buildPdfRow('Tujuan / Lokasi', receipt.destination ?? submission.destination ?? '-'),
              _buildPdfRow('Driver', receipt.driverSnapshot ?? submission.driverSnapshot ?? submission.driverId ?? '-'),
              _buildPdfRow('Kendaraan', receipt.vehicleSnapshot ?? submission.vehicleSnapshot ?? submission.vehicleId ?? '-'),
              _buildPdfRow('Waktu Keluar', _formatDateTime(receipt.checkedOutAt)),
              _buildPdfRow('Waktu Masuk', _formatDateTime(receipt.checkedInAt)),
              pw.SizedBox(height: 24),
              pw.Table(
                border: pw.TableBorder.all(color: pdf.PdfColors.grey600, width: 0.7),
                columnWidths: {
                  0: const pw.FixedColumnWidth(40),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FixedColumnWidth(120),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: pdf.PdfColors.grey200),
                    children: [
                      _tableHeaderCell('No.'),
                      _tableHeaderCell('Jenis Troli'),
                      _tableHeaderCell('Catatan'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _tableCell(_formatSequence(receipt.sequenceNumber)),
                      _tableCell(receipt.status.toUpperCase()),
                      _tableCell(receipt.destination ?? submission.destination ?? '-'),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _signatureBlock('Yang Menerima'),
                  _signatureBlock('Yang Menyerahkan'),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      final bytes = await doc.save();
      final sequence = _formatSequence(receipt.sequenceNumber);
      final filename = 'surat-jalan-$sequence-${receipt.code}.pdf';
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat PDF: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receipts = submission.receipts;

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
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.check_circle_outlined,
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
                            'Data berhasil dikirim',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Surat jalan siap diunduh untuk setiap troli.',
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
                          return _ReceiptCard(
                            receipt: receipt,
                            onExport: () => _exportPdf(context, receipt),
                          );
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Kembali ke Beranda'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRouter.history);
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

  static String _formatSequence(int? sequence) {
    if (sequence == null) return '-';
    return sequence.toString().padLeft(2, '0');
  }

  static String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd MMM yyyy HH:mm').format(value.toLocal());
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 12),
            ),
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
        width: 140,
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: pdf.PdfColors.grey700, width: 0.6)),
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

    String driver = submission.driverSnapshot ??
        firstReceipt?.driverSnapshot ??
        submission.driverId ??
        '-';
    if (driver.trim().isEmpty) driver = '-';

    String vehicle = submission.vehicleSnapshot ??
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
          width: 140,
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
  const _ReceiptCard({
    required this.receipt,
    required this.onExport,
  });

  final MovementReceipt receipt;
  final Future<void> Function() onExport;

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            value: SubmissionSummaryPage._formatSequence(receipt.sequenceNumber),
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
              value:
                  SubmissionSummaryPage._formatDateTime(receipt.checkedInAt),
            ),
          ],
          if ((receipt.destination ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(label: 'Tujuan / Lokasi', value: receipt.destination ?? '-'),
          ],
          if ((receipt.driverSnapshot ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Driver',
              value: receipt.driverSnapshot ?? '-',
            ),
          ],
          if ((receipt.vehicleSnapshot ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Kendaraan',
              value: receipt.vehicleSnapshot ?? '-',
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Export PDF'),
            ),
          ),
        ],
      ),
    );
  }
}
