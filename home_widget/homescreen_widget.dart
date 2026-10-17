import 'package:home_widget_generator/home_widget_generator.dart';

@HomeWidget(
  name: 'home_screen_widget',
  android: HomeWidgetAndroidConfiguration(),
  iOS: HomeWidgetIOSConfiguration(groupId: 'group.com.example.doucodetho'),
  widget: HWColumn(
    children: [
      HWRow(children: [
        HWText.fixed('Hello, '),
        HWText(
          HWString('name', defaultValue: 'User'),
        ),
      ])
    ],
  ),
)
class HomeScreenWidget {}
