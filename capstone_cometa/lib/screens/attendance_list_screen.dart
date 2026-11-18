import 'package:flutter/material.dart';
import '../data/attendance_store.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

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
          if (store.sessionId == null) {
            return const Center(
              child: Text('No session yet. Start one on the home screen.'),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${store.records.length} of ${store.roster.length} present\n'
                  'Tap a student to mark present or absent',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: store.roster.length,
                  itemBuilder: (context, i) {
                    final student = store.roster[i];
                    final record = store.recordFor(student);

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => store.toggleManual(student),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(
                                record != null
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: record != null
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                student.name,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                record != null
                                    ? 'Present at ${TimeOfDay.fromDateTime(record.time).format(context)}'
                                    : 'Absent',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}