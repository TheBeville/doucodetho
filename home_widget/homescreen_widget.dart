import 'package:home_widget_generator/home_widget_generator.dart';

@HomeWidget(
  name: 'home_screen_widget',
  android: HomeWidgetAndroidConfiguration(
    backgroundColor: HWColor.fixed(0xFFFFFFFF),
  ),
  iOS: HomeWidgetIOSConfiguration(groupId: 'group.com.example.doucodetho'),
  widget: HWColumn(
    children: [
      HWRow(
        children: [
          HWText.fixed(
            'Hello, ',
            style: HWTextStyle(
              fontWeight: HWFontWeight.bold,
              color: HWColor.fixed(0xFF000000),
              fontSize: 20.0,
            ),
          ),
          HWText(
            HWString('name', defaultValue: 'User'),
            style: HWTextStyle(
              fontWeight: HWFontWeight.bold,
              color: HWColor.fixed(0xFF000000),
              fontSize: 20.0,
            ),
          ),
        ],
      ),
      HWBoolConditional(
        data: HWBool('dayCompleted', defaultValue: false),
        whenTrue: HWText.fixed(
          '🔥',
          style: HWTextStyle(
            fontWeight: HWFontWeight.bold,
            fontSize: 48.0,
          ),
        ),
        whenFalse: HWText.fixed(
          '❓',
          style: HWTextStyle(
            fontWeight: HWFontWeight.bold,
            fontSize: 48.0,
          ),
        ),
      ),
      HWText.fixed(
        'Current streak',
        style: HWTextStyle(
          color: HWColor.fixed(0xFF000000),
          fontSize: 16.0,
        ),
      ),
      HWText(
        HWInt('currentStreak', defaultValue: 0),
        style: HWTextStyle(
          fontWeight: HWFontWeight.bold,
          color: HWColor.fixed(0xFF000000),
          fontSize: 28.0,
        ),
      ),
    ],
  ),
)
class HomeScreenWidget {}
