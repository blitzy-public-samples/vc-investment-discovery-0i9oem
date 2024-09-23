#!/bin/bash

# Shell script to run tests for all components of the Venture Capital Investment Discovery app

# Function to run backend tests
run_backend_tests() {
    echo "Running backend tests..."
    cd backend
    npm test
    backend_result=$?
    cd ..
    return $backend_result
}

# Function to run frontend tests
run_frontend_tests() {
    echo "Running frontend tests..."
    cd frontend
    npm test
    frontend_result=$?
    cd ..
    return $frontend_result
}

# Function to run iOS tests
run_ios_tests() {
    echo "Running iOS tests..."
    cd ios
    xcodebuild test -workspace VCInvestmentDiscovery.xcworkspace -scheme VCInvestmentDiscovery -destination 'platform=iOS Simulator,name=iPhone 12'
    ios_result=$?
    cd ..
    return $ios_result
}

# Function to run Android tests
run_android_tests() {
    echo "Running Android tests..."
    cd android
    ./gradlew test
    android_result=$?
    cd ..
    return $android_result
}

# Main function to orchestrate running all tests
main() {
    echo "Starting test execution for all components..."

    run_backend_tests
    backend_status=$?

    run_frontend_tests
    frontend_status=$?

    run_ios_tests
    ios_status=$?

    run_android_tests
    android_status=$?

    echo "Test execution completed."
    echo "Summary of test results:"
    echo "Backend tests: $([ $backend_status -eq 0 ] && echo 'PASSED' || echo 'FAILED')"
    echo "Frontend tests: $([ $frontend_status -eq 0 ] && echo 'PASSED' || echo 'FAILED')"
    echo "iOS tests: $([ $ios_status -eq 0 ] && echo 'PASSED' || echo 'FAILED')"
    echo "Android tests: $([ $android_status -eq 0 ] && echo 'PASSED' || echo 'FAILED')"

    # Exit with non-zero status if any test suite failed
    [ $backend_status -eq 0 ] && [ $frontend_status -eq 0 ] && [ $ios_status -eq 0 ] && [ $android_status -eq 0 ]
    exit $?
}

# Execute main function
main