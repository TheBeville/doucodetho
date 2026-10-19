// GENERATED CODE - DO NOT MODIFY BY HAND
//
// This is a placeholder Glance (Jetpack Compose) widget.
package com.example.doucodetho

import androidx.compose.runtime.Composable
import android.content.Context
import androidx.compose.ui.graphics.Color
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Box
import androidx.glance.layout.fillMaxSize
import androidx.glance.text.Text
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetPlugin
import androidx.glance.layout.Column
import androidx.glance.layout.Alignment
import androidx.glance.layout.Row
import androidx.glance.text.TextStyle
import androidx.glance.GlanceTheme
import androidx.core.os.ConfigurationCompat
import java.util.Locale
import java.text.NumberFormat
import androidx.glance.color.ColorProvider
import androidx.compose.ui.unit.dp
import androidx.glance.layout.padding
import androidx.glance.action.clickable
import androidx.glance.action.actionStartActivity

class HomeScreenWidgetHomeWidget : GlanceAppWidget() {
  override val stateDefinition = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent { WidgetContent(context, currentState()) }
  }

  override suspend fun providePreview(context: Context, widgetCategory: Int) {
    provideContent { WidgetContent(context, HomeWidgetGlanceState(HomeWidgetPlugin.getData(context))) }
  }

  fun previewFingerprint(context: Context): String {
    val hwLocales = hwCurrentLocales(context)
    val hwPreviewData =
        HomeScreenWidgetData.fromPreferences(HomeWidgetPlugin.getData(context))
    return listOf(
      "29801b60",
      hwLocales.joinToString(","),
      hwPreviewData.toString(),
    ).joinToString("|")
  }

  @Composable
  private fun WidgetContent(context: Context, currentState: HomeWidgetGlanceState) {
    val prefs = currentState.preferences
    val widgetData = HomeScreenWidgetData.fromPreferences(prefs)
    GlanceTheme {
            Box(modifier = GlanceModifier.background(GlanceTheme.colors.widgetBackground).padding(16.dp).fillMaxSize().clickable(onClick = actionStartActivity<MainActivity>()), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(text = "Hello, ", style = TextStyle(color = GlanceTheme.colors.onSurface))
                        Text(text = widgetData.name ?: "", style = TextStyle(color = GlanceTheme.colors.onSurface))
                    }
                    Text(text = (widgetData.dayCompleted?.toString() ?: "false"), style = TextStyle(color = GlanceTheme.colors.onSurface))
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(text = "Current streak: ", style = TextStyle(color = GlanceTheme.colors.onSurface))
                        Text(text = hwFormatDecimal((widgetData.currentStreak ?: 0L), null, null, true, hwFormatLocale(context)), style = TextStyle(color = GlanceTheme.colors.onSurface))
                    }
                }
            }
    }

  }
}

data class HomeScreenWidgetData(
    val name: String? = null,
    val dayCompleted: Boolean? = null,
    val currentStreak: Long? = null,
) {
    companion object {
        private const val PREFERENCES_PREFIX = "home_widget.HomeScreenWidget"

        fun fromPreferences(prefs: android.content.SharedPreferences): HomeScreenWidgetData {
            return HomeScreenWidgetData(
                name = prefs.getString("${PREFERENCES_PREFIX}.name", "User"),
                dayCompleted = if (prefs.contains("${PREFERENCES_PREFIX}.dayCompleted")) prefs.getBoolean("${PREFERENCES_PREFIX}.dayCompleted", false) else false,
                currentStreak = if (prefs.contains("${PREFERENCES_PREFIX}.currentStreak")) (try { prefs.getInt("${PREFERENCES_PREFIX}.currentStreak", 0).toLong() } catch (_: ClassCastException) { prefs.getLong("${PREFERENCES_PREFIX}.currentStreak", 0L) }) else 0L,
            )
        }
    }
}


private fun hwCurrentLocales(context: Context): List<String> {
    val configured = ConfigurationCompat
        .getLocales(context.resources.configuration)
    val tags = mutableListOf<String>()
    for (index in 0 until configured.size()) {
        val locale = configured[index] ?: continue
        val tag = locale.toLanguageTag()
        if (tag.isNotEmpty() && tag != "und") tags.add(tag)
    }
    if (tags.isEmpty()) {
        val fallback = Locale.getDefault().toLanguageTag()
        if (fallback.isNotEmpty() && fallback != "und") tags.add(fallback)
    }
    return tags
}

private fun hwFormatLocale(context: Context): Locale =
    ConfigurationCompat.getLocales(context.resources.configuration)[0]
        ?: Locale.getDefault()

private fun hwFormatDecimal(
    value: Number,
    minFraction: Int?,
    maxFraction: Int?,
    grouping: Boolean,
    locale: Locale,
): String {
    val formatter = NumberFormat.getNumberInstance(locale)
    formatter.isGroupingUsed = grouping
    minFraction?.let { formatter.minimumFractionDigits = it }
    maxFraction?.let { formatter.maximumFractionDigits = it }
    return formatter.format(value)
}
