#!/bin/bash

# Terraform Automation Script
# Usage: ./terraform.sh [command]
# Commands: init, plan, apply, destroy, output, validate, fmt, refresh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: ./terraform.sh [command]"
    echo ""
    echo "Commands:"
    echo "  init      - Initialize Terraform (i)"
    echo "  plan      - Create execution plan (p)"
    echo "  apply     - Apply changes (a)"
    echo "  destroy   - Destroy infrastructure (d)"
    echo "  output    - Show outputs (o)"
    echo "  validate  - Validate configuration (v)"
    echo "  fmt       - Format code (f)"
    echo "  refresh   - Refresh state (r)"
    echo "  help      - Show this help message (h)"
    echo ""
    echo "Examples:"
    echo "  ./terraform.sh init"
    echo "  ./terraform.sh i        # Short form"
    echo "  ./terraform.sh plan"
    echo "  ./terraform.sh apply"
}

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install it first."
    exit 1
fi

# Get command from argument or default to help
COMMAND=${1:-help}

# Handle short command aliases
case $COMMAND in
    i)
        COMMAND="init"
        ;;
    p)
        COMMAND="plan"
        ;;
    a)
        COMMAND="apply"
        ;;
    d)
        COMMAND="destroy"
        ;;
    o)
        COMMAND="output"
        ;;
    v)
        COMMAND="validate"
        ;;
    f)
        COMMAND="fmt"
        ;;
    r)
        COMMAND="refresh"
        ;;
    h|help)
        show_usage
        exit 0
        ;;
esac

# Change to terraform directory
cd "$(dirname "$0")"

# Execute command
case $COMMAND in
    init)
        print_info "Initializing Terraform..."
        terraform init
        print_info "Initialization complete!"
        ;;
    
    plan)
        print_info "Creating Terraform execution plan..."
        terraform plan
        ;;
    
    apply)
        print_warning "This will create/modify infrastructure. Are you sure? (yes/no)"
        read -r CONFIRM
        if [ "$CONFIRM" = "yes" ] || [ "$CONFIRM" = "y" ]; then
            print_info "Applying Terraform configuration..."
            terraform apply
            print_info "Apply complete! Getting outputs..."
            terraform output
        else
            print_info "Apply cancelled."
            exit 0
        fi
        ;;
    
    destroy)
        print_error "WARNING: This will DESTROY all infrastructure!"
        print_warning "Are you absolutely sure? Type 'yes' to confirm:"
        read -r CONFIRM
        if [ "$CONFIRM" = "yes" ]; then
            print_info "Destroying infrastructure..."
            terraform destroy
            print_info "Destroy complete!"
        else
            print_info "Destroy cancelled."
            exit 0
        fi
        ;;
    
    output)
        print_info "Fetching Terraform outputs..."
        terraform output
        ;;
    
    validate)
        print_info "Validating Terraform configuration..."
        if terraform validate; then
            print_info "✓ Configuration is valid!"
        else
            print_error "✗ Configuration has errors!"
            exit 1
        fi
        ;;
    
    fmt)
        print_info "Formatting Terraform files..."
        terraform fmt -recursive
        print_info "Formatting complete!"
        ;;
    
    refresh)
        print_info "Refreshing Terraform state..."
        terraform refresh
        print_info "Refresh complete!"
        ;;
    
    *)
        print_error "Unknown command: $COMMAND"
        echo ""
        show_usage
        exit 1
        ;;
esac

