package com.example.walletstone

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterFragmentActivity() {
     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    window.addFlags(LayoutParams.FLAG_SECURE)
    super.configureFlutterEngine(flutterEngine)
  }
}