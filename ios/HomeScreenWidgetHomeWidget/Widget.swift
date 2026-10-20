// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Placeholder SwiftUI widget.
//
// App Group ID used here: HomeScreenWidgetHomeWidgetFlavor.appGroupId

import SwiftUI
import WidgetKit

enum HomeScreenWidgetHomeWidgetFlavor {
  static let appGroupId = "group.com.example.doucodetho"
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> HomeScreenWidgetHomeWidgetEntry {
    HomeScreenWidgetHomeWidgetEntry(date: Date(), data: HomeScreenWidgetData.fromUserDefaults(nil))
  }

  func getSnapshot(in context: Context, completion: @escaping (HomeScreenWidgetHomeWidgetEntry) -> Void) {
    let prefs = UserDefaults(suiteName: HomeScreenWidgetHomeWidgetFlavor.appGroupId)
    let data = HomeScreenWidgetData.fromUserDefaults(prefs)

    completion(HomeScreenWidgetHomeWidgetEntry(date: Date(), data: data))

  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let prefs = UserDefaults(suiteName: HomeScreenWidgetHomeWidgetFlavor.appGroupId)
    let data = HomeScreenWidgetData.fromUserDefaults(prefs)

    completion(Timeline(entries: [HomeScreenWidgetHomeWidgetEntry(date: Date(), data: data)], policy: .atEnd))

  }
}

struct HomeScreenWidgetHomeWidgetEntry: TimelineEntry {
  let date: Date
  let data: HomeScreenWidgetData
}


struct HomeScreenWidgetHomeWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Hello, ")
                    .font(.system(size: 20.0, weight: .bold)).foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0))
                Text(entry.data.name ?? "")
                    .font(.system(size: 20.0, weight: .bold)).foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0))
            }
            if entry.data.dayCompleted == true {
                Text("🔥")
                    .font(.system(size: 48.0, weight: .bold))
            } else {
                Text("❓")
                    .font(.system(size: 48.0, weight: .bold))
            }
            Text("Current streak")
                .font(.system(size: 16.0)).foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0))
            Text(hwFormatDecimal(NSNumber(value: entry.data.currentStreak ?? 0), minFraction: nil, maxFraction: nil, grouping: true))
                .font(.system(size: 28.0, weight: .bold)).foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0))
        }
    .applyContainerBackground()
  }
}

struct HomeScreenWidgetHomeWidget: Widget {
  let kind: String = "HomeScreenWidgetHomeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      HomeScreenWidgetHomeWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("home_screen_widget")
  }
}

extension View {
  @ViewBuilder
  func applyContainerBackground() -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      self.containerBackground(.fill.tertiary, for: .widget)
    } else if #available(iOSApplicationExtension 15.0, *) {
      self.background()
    } else {
      self
    }
  }
}

struct HomeScreenWidgetData {
  let name: String?
  let dayCompleted: Bool?
  let currentStreak: Int?

  static let paramPrefix = "home_widget.HomeScreenWidget"

  static func fromUserDefaults(_ defaults: UserDefaults?) -> HomeScreenWidgetData {
    return HomeScreenWidgetData(
      name: (defaults?.string(forKey: "\(paramPrefix).name") ?? "User"),
      dayCompleted: (defaults?.object(forKey: "\(paramPrefix).dayCompleted") as? Bool ?? false),
      currentStreak: (defaults?.object(forKey: "\(paramPrefix).currentStreak") as? Int ?? 0),
    )
  }
}


func hwFormatLocale() -> Locale {
  return Locale.current
}

func hwFormatDecimal(
  _ value: NSNumber, minFraction: Int?, maxFraction: Int?, grouping: Bool
) -> String {
  let formatter = NumberFormatter()
  formatter.locale = hwFormatLocale()
  formatter.numberStyle = .decimal
  formatter.usesGroupingSeparator = grouping
  if let minFraction { formatter.minimumFractionDigits = minFraction }
  if let maxFraction { formatter.maximumFractionDigits = maxFraction }
  return formatter.string(from: value) ?? value.stringValue
}
