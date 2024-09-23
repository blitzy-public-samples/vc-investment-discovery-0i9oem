package com.vcinvestmentdiscovery.services

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton
import com.vcinvestmentdiscovery.util.Constants
import com.vcinvestmentdiscovery.data.models.*

interface APIService {
    @GET("portfolio/overview")
    suspend fun getPortfolioOverview(): PortfolioOverview

    @GET("alerts/recent")
    suspend fun getRecentAlerts(): List<Alert>

    @GET("investments/trending")
    suspend fun getTrendingInvestments(): List<TrendingInvestment>

    @GET("companies/{id}")
    suspend fun getCompanyProfile(@Path("id") companyId: String): Company

    @GET("search")
    suspend fun searchCompanies(
        @Query("query") query: String,
        @Query("filters") filters: String,
        @Query("sort") sort: String
    ): List<SearchResult>
}

@Singleton
class APIServiceImpl @Inject constructor() {
    private val retrofit: Retrofit

    init {
        retrofit = Retrofit.Builder()
            .baseUrl(Constants.API.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    fun getApiService(): APIService {
        return retrofit.create(APIService::class.java)
    }
}