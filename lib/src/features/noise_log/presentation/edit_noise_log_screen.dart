import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/providers.dart';
import '../data/models/noise_log_model.dart';

class EditNoiseLogScreen extends ConsumerStatefulWidget {
  final NoiseLogModel noiseLog;

  const EditNoiseLogScreen({
    super.key,
    required this.noiseLog,
  });

  @override
  ConsumerState<EditNoiseLogScreen> createState() => _EditNoiseLogScreenState();
}

class _EditNoiseLogScreenState extends ConsumerState<EditNoiseLogScreen> {
  late final TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.noiseLog.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedLog = NoiseLogModel(
        id: widget.noiseLog.id,
        userId: widget.noiseLog.userId,
        timestamp: widget.noiseLog.timestamp,
        latitude: widget.noiseLog.latitude,
        longitude: widget.noiseLog.longitude,
        locationName: widget.noiseLog.locationName,
        rmsValue: widget.noiseLog.rmsValue,
        estimatedDb: widget.noiseLog.estimatedDb,
        classification: widget.noiseLog.classification,
        manualLabel: widget.noiseLog.manualLabel,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isDeleted: widget.noiseLog.isDeleted,
      );

      final repository = ref.read(noiseLogRepositoryProvider);
      await repository.updateNoiseLog(updatedLog);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Noise log updated successfully')),
        );
        // Refresh the home screen data
        final currentUserId = ref.read(currentUserIdProvider);
        if (currentUserId != null) {
          ref.refresh(noiseLogsProvider(currentUserId));
        }
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getClassificationLabel() {
    switch (widget.noiseLog.classification) {
      case NoiseClassification.quiet:
        return 'Quiet';
      case NoiseClassification.moderate:
        return 'Moderate';
      case NoiseClassification.noisy:
        return 'Noisy';
    }
  }

  Color _getClassificationColor() {
    switch (widget.noiseLog.classification) {
      case NoiseClassification.quiet:
        return Colors.green;
      case NoiseClassification.moderate:
        return Colors.orange;
      case NoiseClassification.noisy:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, yyyy h:mm a');
    final color = _getClassificationColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Noise Log'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recording Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.noiseLog.estimatedDb.toStringAsFixed(1)} dB',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Recorded Date',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateFormatter.format(widget.noiseLog.timestamp),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.equalizer,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'RMS Value',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.noiseLog.rmsValue.toStringAsFixed(3),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Location Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Location',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.noiseLog.locationName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.noiseLog.latitude.toStringAsFixed(4)}, ${widget.noiseLog.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notes Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Notes (Optional)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Add any additional notes about this noise level...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
