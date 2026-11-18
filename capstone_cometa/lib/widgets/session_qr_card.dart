import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SessionQrCard extends StatelessWidget {
  final String sessionId;
  const SessionQrCard({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
                child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Scan to mark attendance',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            QrImageView(data: 'ATT|$sessionId', size: 220),
          ],
        ),
      ),
    );
  }
}