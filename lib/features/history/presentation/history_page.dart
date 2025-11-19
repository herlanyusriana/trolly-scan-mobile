import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(12, (index) {
      final isOut = index.isOdd;
      return _HistoryItem(
        code: 'LORY-${1000 + index}',
        timestamp: DateTime.now().subtract(Duration(hours: index * 3)),
        location: 'Service Station ${String.fromCharCode(65 + index % 3)}',
        status: isOut ? 'OUT' : 'IN',
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Scan History'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemBuilder: (_, index) => items[index],
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: items.length,
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.code,
    required this.timestamp,
    required this.location,
    required this.status,
  });

  final String code;
  final DateTime timestamp;
  final String location;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOut = status.toUpperCase() == 'OUT';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatTimestamp(timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOut
                  ? const Color.fromRGBO(220, 38, 38, 0.2)
                  : const Color.fromRGBO(22, 163, 74, 0.2),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isOut
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF16A34A),
              ),
            ),
            child: Text(
              status,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isOut
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF16A34A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
