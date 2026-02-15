package com.example.track_my_wallet_finance_app
import android.appwidget.AppWidgetManager
import es.antonborri.home_widget.HomeWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences

class AppWidgetDemo : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }
    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }
    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}
internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    widgetData: SharedPreferences
) {
    val widgetText = widgetData.getString("widget_text", "Hello Widget")

    val views = RemoteViews(context.packageName, R.layout.app_widget_demo)
    views.setTextViewText(R.id.appwidget_text, widgetText)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}
