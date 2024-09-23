import java.text.NumberFormat
import java.util.Locale
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import com.vcinvestmentdiscovery.utils.Constants
import com.vcinvestmentdiscovery.data.models.*
import android.content.Context
import kotlin.random.Random

object Helpers {

    /**
     * Formats a Double value as a currency string
     * @param value The value to format
     * @param currencyCode The currency code (default is USD)
     * @return Formatted currency string
     */
    fun formatCurrency(value: Double, currencyCode: String = "USD"): String {
        val format = NumberFormat.getCurrencyInstance(Locale.US)
        format.currency = java.util.Currency.getInstance(currencyCode)
        return format.format(value)
    }

    /**
     * Calculates the Return on Investment (ROI)
     * @param initialInvestment The initial investment amount
     * @param currentValue The current value of the investment
     * @return Calculated ROI as a percentage
     */
    fun calculateROI(initialInvestment: Double, currentValue: Double): Double {
        val gain = currentValue - initialInvestment
        return (gain / initialInvestment) * 100
    }

    /**
     * Generates a random color for UI elements
     * @return A randomly generated color as an Int
     */
    fun generateRandomColor(): Int {
        return Random.nextInt(0xFF000000.toInt(), 0xFFFFFFFF.toInt())
    }

    /**
     * Creates a debounced version of a suspend function
     * @param delayMillis The delay in milliseconds
     * @param function The function to debounce
     * @return A debounced suspend function
     */
    fun <T> debounce(delayMillis: Long, function: suspend () -> T): suspend () -> T {
        var lastInvocation = 0L
        return {
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastInvocation >= delayMillis) {
                lastInvocation = currentTime
                function()
            } else {
                delay(delayMillis - (currentTime - lastInvocation))
                lastInvocation = System.currentTimeMillis()
                function()
            }
        }
    }

    /**
     * Loads and parses JSON data from an asset file
     * @param context The Android context
     * @param fileName The name of the JSON file in the assets folder
     * @return The contents of the JSON file as a string
     */
    fun loadJSONFromAsset(context: Context, fileName: String): String {
        return try {
            val inputStream = context.assets.open(fileName)
            val size = inputStream.available()
            val buffer = ByteArray(size)
            inputStream.read(buffer)
            inputStream.close()
            String(buffer, Charsets.UTF_8)
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }
}