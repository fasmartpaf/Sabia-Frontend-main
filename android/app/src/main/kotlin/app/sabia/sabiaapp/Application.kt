package app.sabia.sabiaapp;

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import android.content.Context
import androidx.multidex.MultiDex

public class Application: FlutterApplication(), PluginRegistrantCallback {
  override fun onCreate() {
    super.onCreate()
    FlutterFirebaseMessagingService.setPluginRegistrant(this)
  }

  override fun registerWith(registry: PluginRegistry) {
    FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
  }

  override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}