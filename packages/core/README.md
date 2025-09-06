# Meshifi Core Package

This package contains the core Crossplane resources for the Meshifi data mesh platform.

## Resources

- **DataDomain**: Represents a logical data domain in the data mesh
- **DataProduct**: Represents a data product within a domain
- **DataProductMetadata**: Contains metadata and schema information for data products

## Installation

```bash
# Install the core package
kubectl apply -f crds/
kubectl apply -f controllers/
```

## Development

This package is built using the Crossplane CLI and follows the standard Crossplane package structure.
