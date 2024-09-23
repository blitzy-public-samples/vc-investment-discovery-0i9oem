package com.vcinvestmentdiscovery.ui.dashboard

import androidx.arch.core.executor.testing.InstantTaskExecutorRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.vcinvestmentdiscovery.data.repository.DataRepository
import com.vcinvestmentdiscovery.ui.dashboard.DashboardViewModel
import com.vcinvestmentdiscovery.util.MainCoroutineRule
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.runBlockingTest
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.MockitoAnnotations

@ExperimentalCoroutinesApi
@RunWith(AndroidJUnit4::class)
class DashboardViewModelTest {

    @get:Rule
    var instantExecutorRule = InstantTaskExecutorRule()

    @get:Rule
    var mainCoroutineRule = MainCoroutineRule()

    @Mock
    private lateinit var dataRepository: DataRepository

    private lateinit var viewModel: DashboardViewModel

    @Before
    fun setup() {
        MockitoAnnotations.openMocks(this)
        viewModel = DashboardViewModel(dataRepository)
    }

    @Test
    fun testInitialState() {
        assert(viewModel.portfolioOverview.value == null)
        assert(viewModel.recentAlerts.value?.isEmpty() == true)
        assert(viewModel.trendingInvestments.value?.isEmpty() == true)
    }

    @Test
    fun testLoadDashboardData() = runBlockingTest {
        // Set up mock data
        val mockPortfolioOverview = mock(PortfolioOverview::class.java)
        val mockAlerts = listOf(mock(Alert::class.java))
        val mockTrendingInvestments = listOf(mock(TrendingInvestment::class.java))

        `when`(dataRepository.getPortfolioOverview()).thenReturn(mockPortfolioOverview)
        `when`(dataRepository.getRecentAlerts()).thenReturn(mockAlerts)
        `when`(dataRepository.getTrendingInvestments()).thenReturn(mockTrendingInvestments)

        viewModel.loadDashboardData()

        assert(viewModel.portfolioOverview.value == mockPortfolioOverview)
        assert(viewModel.recentAlerts.value == mockAlerts)
        assert(viewModel.trendingInvestments.value == mockTrendingInvestments)
    }

    @Test
    fun testRefreshDashboard() = runBlockingTest {
        // Set up initial mock data
        val initialMockPortfolioOverview = mock(PortfolioOverview::class.java)
        val initialMockAlerts = listOf(mock(Alert::class.java))
        val initialMockTrendingInvestments = listOf(mock(TrendingInvestment::class.java))

        `when`(dataRepository.getPortfolioOverview()).thenReturn(initialMockPortfolioOverview)
        `when`(dataRepository.getRecentAlerts()).thenReturn(initialMockAlerts)
        `when`(dataRepository.getTrendingInvestments()).thenReturn(initialMockTrendingInvestments)

        viewModel.loadDashboardData()

        // Set up updated mock data
        val updatedMockPortfolioOverview = mock(PortfolioOverview::class.java)
        val updatedMockAlerts = listOf(mock(Alert::class.java), mock(Alert::class.java))
        val updatedMockTrendingInvestments = listOf(mock(TrendingInvestment::class.java), mock(TrendingInvestment::class.java))

        `when`(dataRepository.getPortfolioOverview()).thenReturn(updatedMockPortfolioOverview)
        `when`(dataRepository.getRecentAlerts()).thenReturn(updatedMockAlerts)
        `when`(dataRepository.getTrendingInvestments()).thenReturn(updatedMockTrendingInvestments)

        viewModel.refreshDashboard()

        assert(viewModel.portfolioOverview.value == updatedMockPortfolioOverview)
        assert(viewModel.recentAlerts.value == updatedMockAlerts)
        assert(viewModel.trendingInvestments.value == updatedMockTrendingInvestments)
    }

    @Test
    fun testMarkAlertAsRead() = runBlockingTest {
        // Set up mock alerts
        val mockAlerts = listOf(
            Alert(id = "1", isRead = false),
            Alert(id = "2", isRead = false)
        )
        `when`(dataRepository.getRecentAlerts()).thenReturn(mockAlerts)

        viewModel.loadDashboardData()

        val alertToMarkAsRead = mockAlerts[0]
        viewModel.markAlertAsRead(alertToMarkAsRead.id)

        verify(dataRepository).markAlertAsRead(alertToMarkAsRead.id)
        assert(viewModel.recentAlerts.value?.find { it.id == alertToMarkAsRead.id }?.isRead == true)
    }

    @Test
    fun testLoadMoreTrendingInvestments() = runBlockingTest {
        // Set up initial mock trending investments
        val initialMockTrendingInvestments = listOf(mock(TrendingInvestment::class.java))
        `when`(dataRepository.getTrendingInvestments()).thenReturn(initialMockTrendingInvestments)

        viewModel.loadDashboardData()

        // Set up additional mock trending investments
        val additionalMockTrendingInvestments = listOf(mock(TrendingInvestment::class.java), mock(TrendingInvestment::class.java))
        `when`(dataRepository.getMoreTrendingInvestments()).thenReturn(additionalMockTrendingInvestments)

        viewModel.loadMoreTrendingInvestments()

        assert(viewModel.trendingInvestments.value?.size == initialMockTrendingInvestments.size + additionalMockTrendingInvestments.size)
        assert(viewModel.trendingInvestments.value?.containsAll(initialMockTrendingInvestments) == true)
        assert(viewModel.trendingInvestments.value?.containsAll(additionalMockTrendingInvestments) == true)
    }
}