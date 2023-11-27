package ai.clova.eyed.example.utils

import ai.clova.eyed.example.Configuration
import android.content.Context
import org.json.JSONObject

fun getJsonString(context: Context) : String {
    var jsonString = ""
    runCatching {
        val file = context.assets?.open("server/Key.json")
        val size = file?.available()
        val buffer = size?.let { ByteArray(it) }
        file?.read(buffer)
        file?.close()
        jsonString = buffer?.toString(Charsets.UTF_8).toString()
    }.onFailure {
        error(it)
    }
    return jsonString
}


fun jsonParsing(json: String) {
    runCatching {
        val jsonObject = JSONObject(json)
        val documentArray = jsonObject.getJSONArray("DOCUMENT")
        for (i in 0 until documentArray.length()) {
            val obj = documentArray.getJSONObject(i)
            Configuration.idCardInvokeUrl = obj.getString("INVOKE_URL")
            Configuration.idCardSecretKey = obj.getString("SECRET_KEY")
        }
        val compareArray = jsonObject.getJSONArray("COMPARE")
        for (i in 0 until documentArray.length()) {
            val obj = compareArray.getJSONObject(i)
            Configuration.faceInvokeUrl = obj.getString("INVOKE_URL")
            Configuration.faceSecretKey = obj.getString("SECRET_KEY")
        }
    }.onFailure {
        error(it)
    }
}
