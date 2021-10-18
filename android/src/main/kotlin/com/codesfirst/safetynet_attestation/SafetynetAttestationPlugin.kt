package com.codesfirst.safetynet_attestation

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Activity
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.common.api.CommonStatusCodes

import com.google.android.gms.common.api.ApiException

import com.google.android.gms.tasks.OnFailureListener

import com.google.android.gms.tasks.OnSuccessListener

import com.google.android.gms.tasks.Task
import android.text.TextUtils
import android.util.Log
import com.google.android.gms.safetynet.SafetyNet
import com.google.android.gms.safetynet.SafetyNetApi
import com.google.android.gms.safetynet.SafetyNetClient
import com.nimbusds.jose.JWSObject
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.IOException

import java.security.SecureRandom

import java.io.ByteArrayOutputStream
import java.text.ParseException


/** SafetynetAttestationPlugin */
class SafetynetAttestationPlugin(): FlutterPlugin, MethodCallHandler, ActivityAware {
  private var activity: Activity? = null
  private val ANDROID_MANIFEST_METADATA_SAFETY_API_KEY = "safetynet_api_key"

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {}

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "safetynet_attestation")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "checkGooglePlayServicesAvailability" -> checkGooglePlayServicesAvailability(result)
      "requestSafetyNetAttestation" -> requestSafetyNetAttestation(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  //Method of channel
  private fun checkApiKeyInManifest(): Boolean {
    return !TextUtils.isEmpty(getSafetyNetApiKey())
  }

  private fun getNonceFrom(call: MethodCall): ByteArray? {
    return when {
        call.hasArgument("nonce_bytes") -> {
          call.argument("nonce_bytes")
        }
        call.hasArgument("nonce_string") -> {
          getRequestNonce(call.argument("nonce_string") as? String ?: "")
        }
        else -> {
          null
        }
    }
  }

  private fun getRequestNonce(data: String): ByteArray? {
    val byteStream = ByteArrayOutputStream()
    val bytes = ByteArray(24)
    SecureRandom().nextBytes(bytes)
    try {
      byteStream.write(bytes)
      byteStream.write(data.toByteArray())
    } catch (e: IOException) {
      return null
    }
    return byteStream.toByteArray()
  }

  private fun getSafetyNetApiKey(): String? {
    return Utils.getMetadataFromManifest(activity!!, ANDROID_MANIFEST_METADATA_SAFETY_API_KEY)
  }

  private fun checkGooglePlayServicesAvailability(result: Result) {
    when (GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity)) {
      ConnectionResult.SUCCESS -> result.success("success")
      ConnectionResult.SERVICE_MISSING -> result.success("serviceMissing")
      ConnectionResult.SERVICE_UPDATING -> result.success("serviceUpdating")
      ConnectionResult.SERVICE_VERSION_UPDATE_REQUIRED -> result.success("serviceVersionUpdateRequired")
      ConnectionResult.SERVICE_DISABLED -> result.success("serviceDisabled")
      ConnectionResult.SERVICE_INVALID -> result.success("serviceInvalid")
      else -> result.error("Error", "Unknown error code", null)
    }
  }

  private fun requestSafetyNetAttestation(call: MethodCall, result: Result) {
    if (GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity)
            != ConnectionResult.SUCCESS) {
      result.error("Error", "Google Play Services are not available, please call the checkGooglePlayServicesAvailability() method to understand why", null)
      return
    } else if (!checkApiKeyInManifest()) {
      result.error("Error", "The SafetyNet API Key is missing in the manifest", null)
      return
    } else if (!call.hasArgument("nonce_bytes") && !call.hasArgument("nonce_string")) {
      result.error("Error", "Please include the nonce in the request", null)
      return
    }

    // Check nonce
    val nonce: ByteArray? = getNonceFrom(call)
    if (nonce == null || nonce.size < 16) {
      result.error("Error", "The nonce should be larger than the 16 bytes", null)
      return
    }
    val client: SafetyNetClient = SafetyNet.getClient(activity!!)
    val task: Task<SafetyNetApi.AttestationResponse> = client.attest(nonce, getSafetyNetApiKey() ?: "")
    var includePayload:Boolean = false;
    if(call.hasArgument("include_payload")) includePayload = call.argument("include_payload") as? Boolean ?: false
    task.addOnSuccessListener(activity) { attestationResponse ->
      if (includePayload) {
        try {
          val jwsObject: JWSObject = JWSObject.parse(attestationResponse.jwsResult)
          result.success(jwsObject.payload.toString())
        } catch (e: ParseException) {
          e.printStackTrace()
          result.error("Error", e.message, null)
        }
      } else {
        result.success(attestationResponse.jwsResult)
      }
    }.addOnFailureListener(activity) { e ->
      e.printStackTrace()
      if (e is ApiException) {
        result.error("Error",
                CommonStatusCodes.getStatusCodeString(e.statusCode) + " : " +
                        e.message, null)
      } else {
        result.error("Error", e.message, null)
      }
    }
  }
}
