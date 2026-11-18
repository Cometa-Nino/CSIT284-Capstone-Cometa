class Student {
  final String id;
  final String name;
  const Student({required this.id, required this.name});
}

class AttendanceRecord {
  final Student student;
  final DateTime time;
  const AttendanceRecord({required this.student, required this.time});
}