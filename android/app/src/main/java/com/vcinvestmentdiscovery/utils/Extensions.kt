package com.vcinvestmentdiscovery.utils

import android.content.Context
import android.widget.Toast
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.foundation.shape.RoundedCornerShape
import java.text.NumberFormat
import java.util.Locale
import java.text.SimpleDateFormat

// String extensions
fun String.isValidEmail(): Boolean {
    val emailRegex = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+".toRegex()
    return matches(emailRegex)
}

fun String.truncate(length: Int, suffix: String = "..."): String {
    return if (this.length > length) {
        "${this.take(length)}$suffix"
    } else {
        this
    }
}

// Long extensions
fun Long.toFormattedDate(format: String = Constants.DateFormats.DISPLAY_DATE_FORMAT): String {
    val sdf = SimpleDateFormat(format, Locale.getDefault())
    return sdf.format(this)
}

// Double extensions
fun Double.toCurrencyString(): String {
    val format = NumberFormat.getCurrencyInstance(Locale.US)
    return format.format(this)
}

fun Double.toPercentString(): String {
    val format = NumberFormat.getPercentInstance(Locale.getDefault())
    format.maximumFractionDigits = 2
    return format.format(this)
}

// Context extensions
fun Context.showToast(message: String) {
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}

// Modifier extensions
@Composable
fun Modifier.roundedCorners(radius: Int = Constants.UI.CORNER_RADIUS.value.toInt()): Modifier {
    return this.clip(RoundedCornerShape(radius))
}