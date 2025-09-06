# Meshifi Development Makefile
# Alternative to Taskfile for users who prefer Make

.PHONY: help setup dev clean check-deps create-cluster install-crossplane

# Default target
help:
	@echo "Meshifi Development Commands"
	@echo "============================"
	@echo ""
	@echo "Setup:"
	@echo "  setup          - Complete development environment setup"
	@echo "  install-deps   - Install all required dependencies"
	@echo "  check-deps     - Check if required dependencies are installed"
	@echo "  create-cluster - Create Kind cluster"
	@echo "  install-crossplane - Install Crossplane"
	@echo ""
	@echo "Development:"
	@echo "  dev            - Start development environment"
	@echo "  cluster-info   - Show cluster information"
	@echo "  crossplane-status - Check Crossplane status"
	@echo "  logs           - Show Crossplane logs"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean          - Clean up everything"
	@echo ""
	@echo "Note: This Makefile is a wrapper around Task. For more options, use 'task --list'"

# Setup targets
setup: install-deps create-cluster install-crossplane
	@echo "✅ Development environment setup complete!"

install-deps:
	@task install-deps

check-deps:
	@task check-deps

create-cluster:
	@task create-cluster

install-crossplane:
	@task install-crossplane

# Development targets
dev: setup
	@task dev

cluster-info:
	@task cluster-info

crossplane-status:
	@task crossplane-status

logs:
	@task logs

# Cleanup
clean:
	@task clean
