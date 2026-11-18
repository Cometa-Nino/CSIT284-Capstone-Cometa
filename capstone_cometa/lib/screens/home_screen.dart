import 'package:flutter/material.dart';
import '../data/attendance_store.dart';
import '../widgets/session_qr_card.dart';
import 'attendance_list_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AttendanceStore.instance;

    return Scaffold(
           appBar: AppBar(
        title: const Text('Attendance Checker'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final sessionId = store.sessionId;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => store.startSession(),
                    child: const Text('Start new session'),
                  ),
                  const SizedBox(height: 24),
                  if (sessionId != null) ...[
                    SessionQrCard(sessionId: sessionId),
                    const SizedBox(height: 24),
                  ],
                  OutlinedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Student: scan QR'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScannerScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('View attendance list'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AttendanceListScreen()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}