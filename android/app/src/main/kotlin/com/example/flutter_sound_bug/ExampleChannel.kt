package com.example.flutter_sound_bug

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ExampleChannel : FlutterPlugin, MethodChannel.MethodCallHandler {
  private val CHANNEL = "com.dooboolab.example.native"

  private var context: Context? = null
  private var methodChannel: MethodChannel? = null

  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    context = binding.applicationContext
    methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
    methodChannel!!.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    context = null
    methodChannel!!.setMethodCallHandler(null)
    methodChannel = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when(call.method){
      "triggerBug" -> {
        try {
          FlutterEngine(context!!.applicationContext)
          result.success(null)
        } catch (e: Exception) {
          result.error("Failed to launch background service", e.toString(), "")
        }
      }
    }
  }

}