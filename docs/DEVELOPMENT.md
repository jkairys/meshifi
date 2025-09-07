# Development Guide

This guide covers how to set up and work with the Meshifi development environment.

## Prerequisites

Before starting development, ensure you have the following tools installed:

- **Docker**: For running Kind clusters
- **Kind**: Kubernetes in Docker
- **kubectl**: Kubernetes command-line tool
- **Helm**: Package manager for Kubernetes
- **Task**: Task runner (installed automatically by install-deps task)

## Quick Start

1. **Install dependencies and set up environment**:
   ```bash
   task setup
   ```

2. **Start development**:
   ```bash
   task dev
   ```

### Alternative Setup

If you prefer to install dependencies separately:

1. **Install dependencies only**:
   ```bash
   task install-deps
   ```

2. **Set up development environment**:
   ```bash
   task setup-dev
   ```

## Available Tasks

The project uses Task for managing development workflows. Run `task --list` to see all available tasks.

### Common Development Tasks

- `task setup` - Complete environment setup
- `task dev` - Start development environment
- `task cluster-info` - Show cluster information
- `task crossplane-status` - Check Crossplane status
- `task logs` - Show Crossplane logs
- `task clean` - Clean up everything

### Cluster Management

- `task create-cluster` - Create Kind cluster
- `task delete-cluster` - Delete Kind cluster
- `task cluster-info` - Show cluster information

### Crossplane Management

- `task install-crossplane` - Install Crossplane
- `task uninstall-crossplane` - Uninstall Crossplane
- `task crossplane-status` - Check Crossplane status

## Project Structure

```
meshifi/
├── packages/
│   ├── core/           # Core Crossplane package
│   ├── providers/      # Infrastructure providers
│   └── extensions/     # Data product extensions
├── examples/           # Example configurations
├── docs/              # Documentation
├── Taskfile.yml       # Task definitions
└── kind-config.yaml   # Kind cluster configuration
```

## Development Workflow

1. **Start the development environment**:
   ```bash
   task dev
   ```

2. **Check cluster status**:
   ```bash
   task cluster-info
   ```

3. **Monitor Crossplane**:
   ```bash
   task crossplane-status
   ```

4. **View logs**:
   ```bash
   task logs
   ```

5. **Clean up when done**:
   ```bash
   task clean
   ```

## Adding New Features

### Core Package Development

1. Create new CRDs in `packages/core/crds/`
2. Implement controllers in `packages/core/controllers/`
3. Test with the development cluster
4. Update documentation

### Provider Development

1. Create provider directory in `packages/providers/`
2. Add provider configurations
3. Create resource compositions
4. Test with example configurations

### Extension Development

1. Create extension directory in `packages/extensions/`
2. Implement Crossplane package
3. Add to examples
4. Update documentation

## Troubleshooting

### Common Issues

**Kind cluster creation fails**:
- Ensure Docker is running
- Check available disk space
- Try deleting existing clusters: `task delete-cluster`

**Crossplane installation fails**:
- Check cluster connectivity: `task cluster-info`
- Verify Helm is installed: `helm version`
- Check Crossplane logs: `task logs`

**Port conflicts**:
- Check if ports 80, 443, or 30000 are in use
- Modify `kind-config.yaml` to use different ports

### Getting Help

- Check the logs: `task logs`
- Verify cluster status: `task cluster-info`
- Review Crossplane status: `task crossplane-status`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the development environment
5. Submit a pull request

For more information, see the main [README.md](../README.md).
