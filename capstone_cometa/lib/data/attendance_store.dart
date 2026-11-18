import 'package:flutter/foundation.dart';
import '../models/student.dart';

enum MarkResult { success, alreadyMarked, invalidCode, noSession }

const List<Student> dummyStudents = [
  Student(id: 's01', name: 'Ana Reyes'),
  Student(id: 's02', name: 'Ben Santos'),
  Student(id: 's03', name: 'Carla Mendoza'),
  Student(id: 's04', name: 'Dan Cruz'),
  Student(id: 's05', name: 'Eli Torres'),
  Student(id: 's06', name: 'Faith Lim'),
  Student(id: 's07', name: 'Gabe Ramos'),
  Student(id: 's08', name: 'Hana Flores'),
  Student(id: 's09', name: 'Ivan Garcia'),
  Student(id: 's10', name: 'Jade Villanueva'),
];

class AttendanceStore extends ChangeNotifier {
  AttendanceStore._();
  static final AttendanceStore instance = AttendanceStore._();

  final List<Student> roster = dummyStudents;
  final List<AttendanceRecord> _records = [];
  String? _sessionId;

  String? get sessionId => _sessionId;
  List<AttendanceRecord> get records => List.unmodifiable(_records);

  String startSession() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    _records.clear();
    notifyListeners();
    return _sessionId!;
  }

  MarkResult markPresent(String scannedValue, Student student) {
    if (_sessionId == null) return MarkResult.noSession;
    if (scannedValue != 'ATT|$_sessionId') return MarkResult.invalidCode;
    if (recordFor(student) != null) return MarkResult.alreadyMarked;

    _records.add(AttendanceRecord(student: student, time: DateTime.now()));
    notifyListeners();
    return MarkResult.success;
  }

  // Teacher override: marks a student present, or absent if already present
  void toggleManual(Student student) {
    if (_sessionId == null) return;

    final existing = recordFor(student);
    if (existing != null) {
      _records.remove(existing);
    } else {
      _records.add(AttendanceRecord(student: student, time: DateTime.now()));
    }
    notifyListeners();
  }

  AttendanceRecord? recordFor(Student student) {
    for (final r in _records) {
      if (r.student.id == student.id) return r;
    }
    return null;
  }
}