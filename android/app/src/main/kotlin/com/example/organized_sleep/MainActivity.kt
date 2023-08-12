package com.example.organized_sleep

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    var channelName = "Alarm";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName);
        channel.setMethodCallHandler{ call, result->

        if (call.method == "changeImage") {
            result.success("assets/icon/bg3.png")
        }
        }}
}