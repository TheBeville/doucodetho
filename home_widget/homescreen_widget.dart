import 'package:home_widget_generator/home_widget_generator.dart';

const _textColor = HWColor.themed(
  light: HWColor.fixed(0xFF000000),
  dark: HWColor.fixed(0xFFFFFFFF),
);

@HomeWidget(
  name: 'home_screen_widget',
  android: HomeWidgetAndroidConfiguration(
    backgroundColor: HWColor.themed(
      light: HWColor.fixed(0xFFFFFFFF),
      dark: HWColor.fixed(0xFF1C1B1F),
    ),
  ),
  iOS: HomeWidgetIOSConfiguration(
    groupId: 'group.com.example.doucodetho',
    backgroundColor: HWColor.themed(
      light: HWColor.fixed(0xFFFFFFFF),
      dark: HWColor.fixed(0xFF1C1B1F),
    ),
  ),
  widget: HWColumn(
    children: [
      HWRow(
        children: [
          HWText.fixed(
            'Hello, ',
            style: HWTextStyle(
              fontWeight: HWFontWeight.bold,
              color: _textColor,
              fontSize: 20.0,
            ),
          ),
          HWText(
            HWString('name', defaultValue: 'User'),
            style: HWTextStyle(
              fontWeight: HWFontWeight.bold,
              color: _textColor,
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
          color: _textColor,
          fontSize: 16.0,
        ),
      ),
      HWText(
        HWInt('currentStreak', defaultValue: 0),
        style: HWTextStyle(
          fontWeight: HWFontWeight.bold,
          color: _textColor,
          fontSize: 28.0,
        ),
      ),
    ],
  ),
)
class HomeScreenWidget {}
