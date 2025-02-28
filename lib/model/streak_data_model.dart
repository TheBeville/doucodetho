class StreakData {
  final int current;
  final int longest;
  final DateTime lastUpdated;

  StreakData({
    required this.current,
    required this.longest,
    required this.lastUpdated,
  });

  factory StreakData.fromMap(Map<String, dynamic> map) {
    return StreakData(
      current: map['current'] ?? 0,
      longest: map['longest'] ?? 0,
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current': current,
      'longest': longest,
      'last_updated': lastUpdated.toIso8601String().split('T')[0],
    };
  }
}
