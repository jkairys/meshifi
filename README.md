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

1. Install Kubernetes and Crossplane in your cluster
2. Deploy the Meshifi core package
3. Define your first data domain and data product using the provided CRDs
4. Add infrastructure and data product extensions as needed

## Contributing

Contributions are welcome! Please open issues for feature requests, bugs, or questions. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines (coming soon).

## License

Meshifi is [MIT licensed](LICENSE).
