package com.codesfirst.safetynet_attestation

import android.content.pm.PackageManager
import android.content.Context
import androidx.annotation.Nullable


class Utils {
    companion object {
        @Nullable
        fun getMetadataFromManifest(context: Context, key: String): String? {
            return try {
                val ai = context.packageManager.getApplicationInfo(context.packageName, PackageManager.GET_META_DATA)
                val bundle = ai.metaData
                bundle.getString(key)
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }
}