#!/bin/bash

# Venture Capital Investment Discovery App Development Environment Setup

# Function to check if required dependencies are installed
check_dependencies() {
    echo "Checking dependencies..."
    
    # Check for Node.js
    if ! command -v node &> /dev/null; then
        echo "Node.js is not installed. Please install Node.js and try again."
        exit 1
    fi

    # Check for npm
    if ! command -v npm &> /dev/null; then
        echo "npm is not installed. Please install npm and try again."
        exit 1
    fi

    # Check for Docker
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker and try again."
        exit 1
    fi

    # Check for docker-compose
    if ! command -v docker-compose &> /dev/null; then
        echo "docker-compose is not installed. Please install docker-compose and try again."
        exit 1
    fi

    # Check for AWS CLI
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Please install AWS CLI and try again."
        exit 1
    fi

    echo "All dependencies are installed."
}

# Function to set up the backend development environment
setup_backend() {
    echo "Setting up backend environment..."
    
    cd backend
    npm install
    cp .env.example .env
    docker-compose up -d
    npm run migrate
    npm run seed
    cd ..

    echo "Backend setup complete."
}

# Function to set up the frontend development environment
setup_frontend() {
    echo "Setting up frontend environment..."
    
    cd frontend
    npm install
    cp .env.example .env
    # Add any additional frontend setup steps here
    cd ..

    echo "Frontend setup complete."
}

# Function to set up the mobile app development environment
setup_mobile() {
    echo "Setting up mobile app environment..."
    
    cd mobile
    npm install

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Setting up iOS environment..."
        cd ios
        pod install
        cd ..
    fi

    echo "Setting up Android environment..."
    # Add Android-specific setup steps here

    cd ..

    echo "Mobile app setup complete."
}

# Main function to orchestrate the setup process
main() {
    echo "Welcome to the Venture Capital Investment Discovery App Development Environment Setup"

    check_dependencies
    setup_backend
    setup_frontend
    setup_mobile

    echo "Setup complete! You can now start developing the Venture Capital Investment Discovery App."
    echo "To start the development servers, run 'npm run dev' in the respective directories."
}

# Run the main function
main