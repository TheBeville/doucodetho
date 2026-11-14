import 'package:doucodetho/src/home_widget/homescreen_widget.home_widget.dart';

class HomeWidgetService {
  /// Saves widget data and asks Android/iOS launchers to update the display
  Future<void> updateWidgetData({
    String? name,
    int? currentStreak,
    bool? dayCompleted,
    String? themeMode,
  }) async {
    await HomeScreenWidgetHomeWidget.saveData(
      name: name,
      currentStreak: currentStreak,
      dayCompleted: dayCompleted,
      themeMode: themeMode,
    );
    await HomeScreenWidgetHomeWidget.updateWidget();
  }

  /// Updates the widget's theme mode ('light', 'dark', or 'system')
  Future<void> updateThemeMode(String themeMode) async {
    await HomeScreenWidgetHomeWidget.saveData(themeMode: themeMode);
    await HomeScreenWidgetHomeWidget.updateWidget();
  }

  /// Triggers a widget reload
  Future<void> refreshWidget() async {
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
