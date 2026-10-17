// GENERATED CODE - DO NOT MODIFY BY HAND
package com.example.doucodetho

import android.content.Context
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

class HomeScreenWidgetHomeWidgetReceiver : HomeWidgetGlanceWidgetReceiver<HomeScreenWidgetHomeWidget>() {
  override val glanceAppWidget = HomeScreenWidgetHomeWidget()

  override fun previewFingerprint(context: Context): String =
      glanceAppWidget.previewFingerprint(context)
}
