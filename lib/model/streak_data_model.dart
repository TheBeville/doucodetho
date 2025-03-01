class StreakData {
  final int current;
  final int longest;
  final bool dayCompleted;
  final DateTime lastUpdated;

  StreakData({
    required this.current,
    required this.longest,
    required this.dayCompleted,
    required this.lastUpdated,
  });

  factory StreakData.fromMap(Map<String, dynamic> map) {
    return StreakData(
      current: map['current'] ?? 0,
      longest: map['longest'] ?? 0,
      dayCompleted: map['day_completed'] ?? false,
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current': current,
      'longest': longest,
      'day_completed': dayCompleted,
      'last_updated': lastUpdated.toIso8601String().split('T')[0],
    };
  }
}
