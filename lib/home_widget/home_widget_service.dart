import 'package:doucodetho/src/home_widget/homescreen_widget.home_widget.dart';

class HomeWidgetService {
  /// Saves widget data and asks Android/iOS launchers to update the display
  Future<void> updateWidgetData({
    String? name,
    int? currentStreak,
    bool? dayCompleted,
  }) async {
    await HomeScreenWidgetHomeWidget.saveData(
      name: name,
      currentStreak: currentStreak,
      dayCompleted: dayCompleted,
    );
    await HomeScreenWidgetHomeWidget.updateWidget();
  }

  /// Clears widget data when the user signs out
  Future<void> clearWidgetData() async {
    await HomeScreenWidgetHomeWidget.deleteData(
      name: true,
      currentStreak: true,
      dayCompleted: true,
    );
    await HomeScreenWidgetHomeWidget.updateWidget();
  }
}
