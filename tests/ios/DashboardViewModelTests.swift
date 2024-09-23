import XCTest
import Combine
@testable import VCInvestmentDiscovery

class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var mockDataService: MockDataService!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockDataService = MockDataService()
        viewModel = DashboardViewModel(dataService: mockDataService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockDataService = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }

    func testInitialState() {
        XCTAssertNil(viewModel.portfolioOverview)
        XCTAssertTrue(viewModel.recentAlerts.isEmpty)
        XCTAssertTrue(viewModel.trendingInvestments.isEmpty)
    }

    func testLoadDashboardData() {
        let expectation = XCTestExpectation(description: "Load dashboard data")
        
        // Set up mock data
        let mockPortfolioOverview = PortfolioOverview(totalValue: 1000000, dailyChange: 5000)
        let mockAlerts = [Alert(id: UUID(), title: "Test Alert", message: "Test Message", isRead: false)]
        let mockTrendingInvestments = [TrendingInvestment(id: UUID(), name: "Test Investment", sector: "Tech", growthRate: 10)]
        
        mockDataService.mockPortfolioOverview = mockPortfolioOverview
        mockDataService.mockAlerts = mockAlerts
        mockDataService.mockTrendingInvestments = mockTrendingInvestments

        viewModel.loadDashboardData()

        viewModel.$portfolioOverview
            .dropFirst()
            .sink { portfolioOverview in
                XCTAssertEqual(portfolioOverview, mockPortfolioOverview)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.recentAlerts.isEmpty)
        XCTAssertEqual(viewModel.recentAlerts, mockAlerts)
        XCTAssertFalse(viewModel.trendingInvestments.isEmpty)
        XCTAssertEqual(viewModel.trendingInvestments, mockTrendingInvestments)
    }

    func testRefreshDashboard() {
        let expectation = XCTestExpectation(description: "Refresh dashboard data")
        
        // Set up initial mock data
        let initialPortfolioOverview = PortfolioOverview(totalValue: 1000000, dailyChange: 5000)
        mockDataService.mockPortfolioOverview = initialPortfolioOverview
        
        viewModel.loadDashboardData()
        
        // Update mock data
        let updatedPortfolioOverview = PortfolioOverview(totalValue: 1100000, dailyChange: 10000)
        mockDataService.mockPortfolioOverview = updatedPortfolioOverview
        
        viewModel.refreshDashboard()
        
        viewModel.$portfolioOverview
            .dropFirst(2) // Drop the initial value and the first update
            .sink { portfolioOverview in
                XCTAssertEqual(portfolioOverview, updatedPortfolioOverview)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testMarkAlertAsRead() {
        let expectation = XCTestExpectation(description: "Mark alert as read")
        
        let mockAlerts = [
            Alert(id: UUID(), title: "Test Alert 1", message: "Test Message 1", isRead: false),
            Alert(id: UUID(), title: "Test Alert 2", message: "Test Message 2", isRead: false)
        ]
        mockDataService.mockAlerts = mockAlerts
        
        viewModel.loadDashboardData()
        
        let alertToMark = mockAlerts[0]
        viewModel.markAlertAsRead(alertToMark.id)
        
        viewModel.$recentAlerts
            .dropFirst(2) // Drop the initial value and the first update
            .sink { alerts in
                XCTAssertTrue(alerts.first { $0.id == alertToMark.id }?.isRead ?? false)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadMoreTrendingInvestments() {
        let expectation = XCTestExpectation(description: "Load more trending investments")
        
        let initialTrendingInvestments = [
            TrendingInvestment(id: UUID(), name: "Initial Investment 1", sector: "Tech", growthRate: 10),
            TrendingInvestment(id: UUID(), name: "Initial Investment 2", sector: "Finance", growthRate: 8)
        ]
        mockDataService.mockTrendingInvestments = initialTrendingInvestments
        
        viewModel.loadDashboardData()
        
        let additionalTrendingInvestments = [
            TrendingInvestment(id: UUID(), name: "Additional Investment 1", sector: "Healthcare", growthRate: 12),
            TrendingInvestment(id: UUID(), name: "Additional Investment 2", sector: "Energy", growthRate: 9)
        ]
        mockDataService.mockAdditionalTrendingInvestments = additionalTrendingInvestments
        
        viewModel.loadMoreTrendingInvestments()
        
        viewModel.$trendingInvestments
            .dropFirst(2) // Drop the initial value and the first update
            .sink { investments in
                XCTAssertEqual(investments.count, initialTrendingInvestments.count + additionalTrendingInvestments.count)
                XCTAssertTrue(investments.contains(where: { $0.name == "Additional Investment 1" }))
                XCTAssertTrue(investments.contains(where: { $0.name == "Additional Investment 2" }))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}