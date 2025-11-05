# meshifi

a data mesh abstraction for humans

# Meshifi

Meshifi is an open-source data mesh platform designed to bring modern data product thinking to Kubernetes-native environments. By leveraging the Kubernetes resource model and the extensibility of Crossplane, Meshifi enables organizations to define, provision, and manage data products as first-class resources, integrating seamlessly with cloud-native infrastructure and popular data tooling.

## Purpose

Meshifi aims to:

- **Model Logical Data Domains:** Provide a robust domain model for representing logical data products, domains, and their relationships as Kubernetes custom resources.
- **Enable Data Product Capabilities:** Support extensions for data modeling (e.g., DBT), data ingestion (e.g., Fivetran), and other data product lifecycle features.
- **Automate Infrastructure Provisioning:** Use Crossplane to declaratively provision and manage the infrastructure required for data products, such as databases, storage, and compute resources.
- **Promote Platform Extensibility:** Allow new data product capabilities and providers to be added via Crossplane packages or similar extension mechanisms.

## Architecture Overview

- **Domain Model:**
  - Core Crossplane package defines custom resources for logical data domains, products, and their metadata.
- **Infrastructure Providers:**
  - Crossplane providers manage cloud and on-prem infrastructure, enabling declarative provisioning of data product dependencies.
- **Extensions:**
  - Integrations for tools like DBT (for data modeling) and Fivetran (for data ingestion) are delivered as Crossplane packages or similar extensions.
- **Service Implementation:**
  - All services and capabilities are implemented as Crossplane packages or compatible Kubernetes-native controllers.

## Roadmap

### Milestone 1: Core Platform

- Define and implement the core domain model as a Crossplane package
- Basic CRDs for data domains, data products, and product metadata
- Documentation and examples for deploying the core package

### Milestone 2: Infrastructure Integration

- Integrate Crossplane providers for major cloud platforms (AWS, GCP, Azure)
- Enable declarative provisioning of data infrastructure (databases, storage, compute)
- Example blueprints for common data product infrastructure

### Milestone 3: Data Product Extensions

- DBT extension for data modeling as a managed resource
- Fivetran extension for data ingestion pipelines
- Framework for adding additional data product capabilities

### Milestone 4: Ecosystem & Usability

- CLI and UI for managing data mesh resources
- Templates and best practices for data product teams
- Community-contributed extensions and providers

## Getting Started

> **Note:** Meshifi is in early development. Please see the roadmap for planned features and contribute via issues or pull requests!

### Quick Start - Run Full Verification

The fastest way to test Meshifi is to run the complete verification workflow:

```bash
task verify
```

This single command will:
- Create a Kind cluster
- Install Crossplane with required functions
- Install the Meshifi platform (XRDs and compositions)
- Deploy and test example DataDomain and DataProduct resources
- Show cluster status and validation results
- Clean up test resources (but keeps the cluster running)

After verification completes, you can experiment with the platform or run `task cleanup` to remove everything.

### Golden Path - Complete Setup

Follow these steps to get a fully functional Meshifi development environment:

1. **Install dependencies and set up environment**:

   ```bash
   cd dev-environment
   task setup
   ```

   This will:

   - Install all required dependencies (Docker, Kind, kubectl, Helm, Crossplane CLI)
   - Create a Kind cluster named `meshifi-dev`
   - Install Crossplane v2.0.2

2. **Install the Meshifi composition and example**:

   ```bash
   cd ../platform
   task install
   ```

   This will:

   - Install the Meshifi core package (CRDs and compositions)
   - Set up the data domain resource definitions

3. **Test with the example**:
   ```bash
   kubectl apply -f examples/data-domain.yaml
   kubectl get datadomains
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

### Available Commands

From the root directory, you can run:

```bash
task --list          # Show all available tasks
task verify          # Run complete verification workflow
task setup-dev       # Set up dev environment (cluster + Crossplane)
task test-platform   # Install and test the platform
task show-status     # Show cluster and platform status
task debug           # Show detailed debug information
task cleanup         # Clean up environment (removes cluster)
task install         # Install the Meshifi platform
task install-samples # Install sample resources
```

### Project Structure

```
meshifi/
├── Taskfile.yml             # Root-level orchestration tasks
├── dev-environment/         # Development environment setup
│   ├── dependencies/        # Dependency management tasks
│   ├── kind/               # Kind cluster management
│   ├── crossplane/         # Crossplane installation tasks
│   ├── crossplane-gcp/     # GCP provider setup
│   └── Taskfile.yaml       # Dev environment orchestrator
├── platform/               # Meshifi platform components
│   ├── core/               # Core platform (XRDs, compositions, functions)
│   ├── examples/           # Example configurations
│   └── Taskfile.yml        # Platform management tasks
├── docs/                   # Documentation
└── README.md              # This file
```

### Development

For detailed development instructions, see [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## Contributing

Contributions are welcome! Please open issues for feature requests, bugs, or questions.

## License

Meshifi is open source. See the repository for license information.
