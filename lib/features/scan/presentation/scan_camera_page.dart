import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../utils/trolley_code_parser.dart';

class ScanCameraPage extends StatefulWidget {
  const ScanCameraPage({super.key});

  @override
  State<ScanCameraPage> createState() => _ScanCameraPageState();
}

class _ScanCameraPageState extends State<ScanCameraPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  final Set<String> _scannedCodes = <String>{};
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) async {
    if (!mounted || _isProcessing) return;
    final codes = capture.barcodes
        .map((barcode) => parseTrolleyCode(barcode.rawValue))
        .whereType<String>()
        .where((code) => !_scannedCodes.contains(code))
        .toList();

    if (codes.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _scannedCodes.addAll(codes);
    });

    await HapticFeedback.mediumImpact();

    if (!mounted) return;
    final snackBar = SnackBar(
      content: Text('${codes.first} ditambahkan'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1200),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _addManualCode() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah kode manual'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Masukkan kode troli'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );

    if (!mounted || (result == null) || result.isEmpty) return;

    final normalized = parseTrolleyCode(result);
    if (normalized == null || _scannedCodes.contains(normalized)) {
      return;
    }

    setState(() {
      _scannedCodes.add(normalized);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Troli'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _controller.torchState,
            builder: (context, state, _) {
              final isOn = state == TorchState.on;
              return IconButton(
                icon: Icon(
                  isOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                ),
                onPressed: () => _controller.toggleTorch(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: _handleDetection,
          ),
          _ScannerOverlay(
            count: _scannedCodes.length,
            lastCode: _scannedCodes.isEmpty ? null : _scannedCodes.last,
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_scannedCodes.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total scan: ${_scannedCodes.length}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _scannedCodes
                              .map(
                                (code) => Chip(
                                  label: Text(code),
                                  backgroundColor: const Color(0xFF2563EB),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addManualCode,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.45),
                        ),
                        icon: const Icon(Icons.edit_note_rounded),
                        label: const Text('Input Manual'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _scannedCodes.isEmpty
                            ? null
                            : () => Navigator.of(
                                context,
                              ).pop(_scannedCodes.toList()),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Selesai'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.count, this.lastCode});

  final int count;
  final String? lastCode;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.25)),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          Positioned(
            top: 32,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Arahkan kamera ke QR / barcode troli',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Berhasil scan: $count',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                if (lastCode != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lastCode!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
