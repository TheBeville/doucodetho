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
                Text(entry.data.name ?? "")
            }
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

  static let paramPrefix = "home_widget.HomeScreenWidget"

  static func fromUserDefaults(_ defaults: UserDefaults?) -> HomeScreenWidgetData {
    return HomeScreenWidgetData(
      name: (defaults?.string(forKey: "\(paramPrefix).name") ?? "User"),
    )
  }
}

