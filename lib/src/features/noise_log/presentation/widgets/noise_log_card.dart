import 'package:flutter/material.dart';
import '../../data/models/noise_log_model.dart';
import 'package:intl/intl.dart';

class NoiseLogCard extends StatelessWidget {
  final NoiseLogModel noiseLog;

  const NoiseLogCard({
    super.key,
    required this.noiseLog,
  });

  Color _getClassificationColor() {
    switch (noiseLog.classification) {
      case NoiseClassification.quiet:
        return Colors.green;
      case NoiseClassification.moderate:
        return Colors.orange;
      case NoiseClassification.noisy:
        return Colors.red;
    }
  }

  String _getClassificationLabel() {
    switch (noiseLog.classification) {
      case NoiseClassification.quiet:
        return 'Quiet';
      case NoiseClassification.moderate:
        return 'Moderate';
      case NoiseClassification.noisy:
        return 'Noisy';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getClassificationColor();
    final dateFormatter = DateFormat('MMM d, yyyy h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noiseLog.locationName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatter.format(noiseLog.timestamp),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    _getClassificationLabel(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    label: 'dB Level',
                    value: '${noiseLog.estimatedDb.toStringAsFixed(1)} dB',
                    icon: Icons.volume_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    label: 'RMS Value',
                    value: noiseLog.rmsValue.toStringAsFixed(3),
                    icon: Icons.equalizer,
                  ),
                ),
              ],
            ),
            if (noiseLog.notes != null && noiseLog.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      noiseLog.notes!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
