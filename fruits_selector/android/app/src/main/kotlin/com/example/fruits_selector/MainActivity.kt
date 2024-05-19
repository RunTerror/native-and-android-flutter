package com.example.fruits_selector

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fruits_selector/select_fruits"
    private val REQUEST_CODE_SELECT_FRUITS = 1

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "selectFruits") {
                val intent = Intent(this, FruitSelectionActivity::class.java)
                startActivityForResult(intent, REQUEST_CODE_SELECT_FRUITS)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_SELECT_FRUITS && resultCode == Activity.RESULT_OK) {
            val selectedFruits = data?.getStringArrayListExtra("selectedFruits")
            if (selectedFruits != null) {
                MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL).invokeMethod("selectedFruits", selectedFruits)
            }
        }
    }
}
