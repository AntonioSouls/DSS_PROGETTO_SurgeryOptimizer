class Intervention {
  String name;
  int hours;
  int minutes;
  List<int> compatibleRoomIds; // 1-based: 1..5

  Intervention({
    required this.name,
    required this.hours,
    required this.minutes,
    required this.compatibleRoomIds,
  });

  String get durationLabel {
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}min';
    if (hours > 0) return '${hours}h';
    return '${minutes}min';
  }

  int get totalMinutes => hours * 60 + minutes;

  Map<String, dynamic> toJson() => {
        'name': name,
        'hours': hours,
        'minutes': minutes,
        'compatibleRoomIds': compatibleRoomIds,
      };

  factory Intervention.fromJson(Map<String, dynamic> json) => Intervention(
        name: json['name'] as String,
        hours: json['hours'] as int,
        minutes: json['minutes'] as int,
        compatibleRoomIds:
            (json['compatibleRoomIds'] as List).cast<int>(),
      );
}
