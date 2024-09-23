#!/bin/bash

# Venture Capital Investment Discovery App Production Deployment Script

set -e

# Global variables
AWS_REGION="us-west-2"
ECR_REPOSITORY="vc-investment-discovery"
ECS_CLUSTER="vc-investment-discovery-cluster"
ECS_SERVICE="vc-investment-discovery-service"

# Function to check AWS credentials
check_aws_credentials() {
    echo "Checking AWS credentials..."
    if ! aws sts get-caller-identity &> /dev/null; then
        echo "Error: AWS credentials are not properly configured. Please set up your AWS CLI."
        exit 1
    fi
    echo "AWS credentials are valid."
}

# Function to build and push Docker image to ECR
build_and_push_image() {
    echo "Building and pushing Docker image to ECR..."
    
    # Login to ECR
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY
    
    # Build Docker image
    docker build -t $ECR_REPOSITORY:latest .
    
    # Tag Docker image
    docker tag $ECR_REPOSITORY:latest $ECR_REPOSITORY:$GITHUB_SHA
    
    # Push Docker image to ECR
    docker push $ECR_REPOSITORY:latest
    docker push $ECR_REPOSITORY:$GITHUB_SHA
    
    echo "Docker image built and pushed successfully."
}

# Function to update ECS service
update_ecs_service() {
    echo "Updating ECS service..."
    
    # Update ECS service to force new deployment
    aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --force-new-deployment
    
    # Wait for service to stabilize
    aws ecs wait services-stable --cluster $ECS_CLUSTER --services $ECS_SERVICE
    
    echo "ECS service updated successfully."
}

# Function to run database migrations
run_database_migrations() {
    echo "Running database migrations..."
    
    # TODO: Implement secure method to connect to production database
    # TODO: Determine appropriate migration tool and command
    
    echo "Database migrations completed."
}

# Main function
main() {
    echo "Starting deployment process..."
    
    check_aws_credentials
    build_and_push_image
    run_database_migrations
    update_ecs_service
    
    echo "Deployment completed successfully."
}

# Run the main function
main