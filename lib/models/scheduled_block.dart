class ScheduledBlock {
  final String interventionName;
  final int deptId;
  final int roomId;
  final int day;
  final int startMinutes; // minuti dalla mezzanotte
  final int endMinutes;

  const ScheduledBlock({
    required this.interventionName,
    required this.deptId,
    required this.roomId,
    required this.day,
    required this.startMinutes,
    required this.endMinutes,
  });

  String get timeLabel {
    String fmt(int m) =>
        '${m ~/ 60}:${(m % 60).toString().padLeft(2, '0')}';
    return '${fmt(startMinutes)}-${fmt(endMinutes)}';
  }

  Map<String, dynamic> toJson() => {
        'interventionName': interventionName,
        'deptId': deptId,
        'roomId': roomId,
        'day': day,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };

  factory ScheduledBlock.fromJson(Map<String, dynamic> json) => ScheduledBlock(
        interventionName: json['interventionName'] as String,
        deptId: json['deptId'] as int,
        roomId: json['roomId'] as int,
        day: json['day'] as int,
        startMinutes: json['startMinutes'] as int,
        endMinutes: json['endMinutes'] as int,
      );
}
