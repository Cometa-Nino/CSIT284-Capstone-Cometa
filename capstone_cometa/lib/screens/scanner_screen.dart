import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/attendance_store.dart';
import '../models/student.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _store = AttendanceStore.instance;
  final MobileScannerController _controller = MobileScannerController();
  Student? _student;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_busy || _student == null || capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue;
    if (value == null) return;

    _busy = true;
    final result = _store.markPresent(value, _student!);
    final message = switch (result) {
      MarkResult.success => '${_student!.name} marked present',
      MarkResult.alreadyMarked => 'Already marked present',
      MarkResult.invalidCode => 'Invalid QR code for this class',
      MarkResult.noSession => 'No active session',
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<Student>(
              hint: const Text('Select your name'),
              value: _student,
              isExpanded: true,
              items: _store.roster
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (s) => setState(() => _student = s),
            ),
          ),
          Expanded(
            child: _student == null
                ? const Center(child: Text('Select your name to start scanning'))
                : MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                  ),
          ),
        ],
      ),
    );
  }
}