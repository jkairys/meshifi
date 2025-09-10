# Development Guide

This guide covers how to set up and work with the Meshifi development environment.

## Prerequisites

Before starting development, ensure you have the following tools installed:

- **Docker**: For running Kind clusters
- **Kind**: Kubernetes in Docker
- **kubectl**: Kubernetes command-line tool
- **Helm**: Package manager for Kubernetes
- **Task**: Task runner (installed automatically by install-deps task)

### For GCP Integration (Optional)

If you plan to use GCP resources with Crossplane:

- **gcloud CLI**: Google Cloud SDK
- **GCP Project**: Valid GCP project with billing enabled
- **Authentication**: `gcloud auth login` completed

## Quick Start

1. **Set up development environment**:

   ```bash
   cd dev-environment
   task setup
   ```

2. **Install Meshifi platform**:

   ```bash
   cd ../platform
   task install
   ```

3. **Test with example**:
   ```bash
   kubectl apply -f examples/data-domain.yaml
   kubectl get datadomains
   ```

### With GCP Integration

If you want to use GCP resources:

1. **Set up development environment**:

   ```bash
   cd dev-environment
   task setup
   ```

2. **Set up GCP provider**:

   ```bash
   export GCP_PROJECT_ID=your-project-id
   cd crossplane-gcp
   task setup
   ```

3. **Install Meshifi platform**:

   ```bash
   cd ../../platform
   task install
   ```

4. **Test with GCP example**:
   ```bash
   kubectl apply -f examples/gcp-data-domain.yaml
   kubectl get gcpdatadomains
   ```

### Alternative Setup

If you prefer to install components separately:

1. **Install dependencies only**:

   ```bash
   cd dev-environment
   task install-deps
   ```

2. **Create cluster only**:

   ```bash
   task create-cluster
   ```

3. **Install Crossplane only**:

   ```bash
   task install-crossplane
   ```

4. **Install Meshifi platform**:

   ```bash
   cd ../platform
   task install
   ```

5. **Set up GCP provider (optional)**:
   ```bash
   export GCP_PROJECT_ID=your-project-id
   cd ../dev-environment/crossplane-gcp
   task setup
   ```

## Available Tasks

The project uses a modular Task structure with separate taskfiles for different concerns.

### Development Environment Tasks (dev-environment/)

Run these from the `dev-environment/` directory:

**Main Setup Tasks:**

- `task setup` - Complete environment setup (dependencies + cluster + Crossplane)
- `task install-deps` - Install all required dependencies
- `task create-cluster` - Create Kind cluster
- `task install-crossplane` - Install Crossplane
- `task clean` - Clean up everything

**Individual Component Tasks:**

- `task cluster-info` - Show cluster information
- `task crossplane-status` - Check Crossplane status
- `task logs` - Show Crossplane logs
- `task port-forward` - Port forward Crossplane API server

**GCP Provider Tasks:**

Run these from the `dev-environment/crossplane-gcp/` directory:

- `task setup` - Complete GCP provider setup
- `task create-gcp-key` - Create GCP service account and store key
- `task install-gcp-providers` - Install GCP providers from Upbound
- `task configure-gcp-provider` - Configure provider with credentials
- `task debug-provider-config` - Debug GCP provider configuration

### Platform Tasks (platform/)

Run these from the `platform/` directory:

- `task install` - Install Meshifi core package
- `task uninstall` - Uninstall Meshifi package
- `task status` - Check package status
- `task test` - Test with example resources

## Project Structure

```
meshifi/
├── dev-environment/          # Development environment setup
│   ├── dependencies/         # Dependency management tasks
│   │   └── Taskfile.yaml    # Install Docker, Kind, kubectl, Helm, etc.
│   ├── kind/                # Kind cluster management
│   │   ├── Taskfile.yaml    # Create/delete Kind clusters
│   │   └── kind-config.yaml # Kind cluster configuration
│   ├── crossplane/          # Crossplane core installation tasks
│   │   └── Taskfile.yaml    # Install/manage Crossplane core
├── crossplane-gcp/      # GCP provider installation tasks
│   │   ├── Taskfile.yaml    # Install/manage GCP providers
│   │   ├── provider-config.yaml # GCP provider configuration
│   │   └── providers/        # GCP provider definitions
│   └── Taskfile.yaml        # Main dev environment orchestrator
├── platform/                # Meshifi platform components
│   ├── core/                # Core Crossplane package
│   │   ├── xrd.yaml         # CompositeResourceDefinition
│   │   ├── composition.yaml # Crossplane composition
│   │   └── fn.yaml          # Function definitions
│   ├── examples/            # Example configurations
│   │   ├── data-domain.yaml # Example data domain
│   │   └── README.md        # Example documentation
│   └── Taskfile.yml         # Platform management tasks
├── docs/                    # Documentation
│   ├── DEVELOPMENT.md       # This file
│   └── TASKFILE_STRUCTURE.md # Task structure documentation
└── README.md               # Main project documentation
```

## Development Workflow

1. **Set up the development environment**:

   ```bash
   cd dev-environment
   task setup
   ```

2. **Install the Meshifi platform**:

   ```bash
   cd ../platform
   task install
   ```

3. **Check cluster status**:

   ```bash
   cd ../dev-environment
   task cluster-info
   ```

4. **Monitor Crossplane**:

   ```bash
   task crossplane-status
   ```

5. **Test with example**:

   ```bash
   cd ../platform
   kubectl apply -f examples/data-domain.yaml
   kubectl get datadomains
   ```

6. **Set up GCP provider (optional)**:

   ```bash
   export GCP_PROJECT_ID=your-project-id
   cd ../dev-environment/crossplane-gcp
   task setup
   ```

7. **Test with GCP example (if GCP provider is set up)**:

   ```bash
   cd ../../platform
   kubectl apply -f examples/gcp-data-domain.yaml
   kubectl get gcpdatadomains
   ```

8. **View logs**:

   ```bash
   cd ../dev-environment
   task logs
   ```

9. **Clean up when done**:
   ```bash
   task clean
   ```

## Adding New Features

### Core Package Development

1. Create new CRDs in `platform/core/`
2. Update compositions in `platform/core/composition.yaml`
3. Add function definitions in `platform/core/fn.yaml`
4. Test with the development cluster
5. Update documentation

### Example Development

1. Create new examples in `platform/examples/`
2. Add YAML manifests for new resource types
3. Update `platform/examples/README.md`
4. Test examples with the development cluster

### Platform Extensions

1. Create new composition files in `platform/core/`
2. Add new function definitions as needed
3. Create example configurations
4. Update platform taskfile if needed

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

**GCP provider issues**:

- Ensure GCP_PROJECT_ID is set: `echo $GCP_PROJECT_ID`
- Check gcloud authentication: `gcloud auth list`
- Verify required APIs are enabled: `gcloud services list --enabled`
- Debug provider config: `cd dev-environment/crossplane-gcp && task debug-provider-config`

**Port conflicts**:

- Check if ports 80, 443, or 30000 are in use
- Modify `kind-config.yaml` to use different ports

### Getting Help

- Check the logs: `cd dev-environment && task logs`
- Verify cluster status: `cd dev-environment && task cluster-info`
- Review Crossplane status: `cd dev-environment && task crossplane-status`
- Check GCP provider status: `cd dev-environment/crossplane-gcp && task debug-provider-config`
- Check platform status: `cd platform && task status`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the development environment
5. Submit a pull request

For more information, see the main [README.md](../README.md).
