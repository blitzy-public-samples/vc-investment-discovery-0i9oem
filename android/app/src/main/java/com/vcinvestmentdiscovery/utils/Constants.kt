package com.vcinvestmentdiscovery.utils

import androidx.compose.ui.unit.dp

object Constants {

    object API {
        const val BASE_URL = "https://api.vcinvestmentdiscovery.com/"
        const val API_VERSION = "v1"
        const val TIMEOUT_SECONDS = 30L
    }

    object SharedPreferences {
        const val PREF_NAME = "VCInvestmentDiscoveryPrefs"
        const val KEY_USER_TOKEN = "user_token"
        const val KEY_LAST_SYNC_TIMESTAMP = "last_sync_timestamp"
        const val KEY_USER_PREFERENCES = "user_preferences"
    }

    object Notifications {
        const val CHANNEL_ID = "vc_investment_discovery_channel"
        const val CHANNEL_NAME = "VC Investment Discovery"
        const val NOTIFICATION_ID_NEW_INVESTMENT_OPPORTUNITY = 1001
        const val NOTIFICATION_ID_PORTFOLIO_UPDATE = 1002
        const val NOTIFICATION_ID_MARKET_ALERT = 1003
    }

    object DateFormats {
        const val ISO_8601_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        const val DISPLAY_DATE_FORMAT = "MMM dd, yyyy"
        const val DISPLAY_DATE_TIME_FORMAT = "MMM dd, yyyy HH:mm"
    }

    object UI {
        val CORNER_RADIUS = 8.dp
        const val ANIMATION_DURATION = 300L
        val DEFAULT_PADDING = 16.dp
    }

    object ErrorMessages {
        const val NETWORK_ERROR = "Network error. Please check your connection and try again."
        const val AUTHENTICATION_FAILED = "Authentication failed. Please log in again."
        const val DATA_LOAD_FAILED = "Failed to load data. Please try again."
    }
}