# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Meshifi is a data mesh platform built on Kubernetes and Crossplane that enables declarative provisioning of data products in GCP. The platform abstracts complex infrastructure into simple YAML interfaces designed for data analysts with minimal cloud infrastructure experience.

**Target Persona**: Data analysts familiar with SQL, minimal YAML/Git experience, no cloud infrastructure experience.

**Core Concept**: Users define high-level data products and domains using simple YAML manifests. Crossplane compositions translate these into actual GCP resources (BigQuery datasets, IAM service accounts, permissions).

## Architecture

### Key Components

1. **Composite Resource Definitions (XRDs)**: Define the schema for user-facing resources
   - `DataDomain` (`platform/core/xrds/data-domain.yaml`): Logical grouping for data products
   - `DataProduct` (`platform/core/xrds/data-product.yaml`): Individual data products with BigQuery datasets

2. **Compositions**: Business logic that transforms user intent into GCP resources
   - Uses Crossplane pipeline mode with Go templating functions
   - Provisions BigQuery datasets (raw/cleaned/curated), service accounts, and IAM bindings
   - Located in `platform/core/compositions/`

3. **Crossplane Functions**: Installed via `platform/core/functions.yaml`
   - `function-go-templating`: Template-based resource generation
   - `function-auto-ready`: Automatic readiness detection
   - `function-extra-resources`: Cross-resource references

### Resource Model

- **DataProduct** references a **DataDomain** via `spec.dataDomainRef`
- DataProducts can enable datasets (raw, cleaned, curated) as boolean flags
- Compositions use these flags to conditionally provision BigQuery datasets
- Each DataProduct gets its own IAM service account with appropriate permissions

## Development Commands

### Initial Setup

```bash
# Complete development environment setup
cd dev-environment
task setup    # Installs deps, creates cluster, installs Crossplane

# Install Meshifi platform (CRDs and compositions)
cd ../platform
task install
```

### GCP Provider Setup (Optional)

```bash
export GCP_PROJECT_ID=your-project-id
cd dev-environment/crossplane-gcp
task setup    # Creates service account, installs providers, configures credentials
```

### Common Development Tasks

```bash
# Check cluster status
cd dev-environment
task cluster-info

# Check Crossplane status
task crossplane-status

# View Crossplane logs
task logs

# Install/reinstall platform
cd ../platform
task install
task uninstall

# Test with examples
kubectl apply -f examples/data-domain.yaml
kubectl get datadomains
kubectl apply -f examples/data-product.yaml
kubectl get dataproducts

# Clean up everything (in correct order: platform → Crossplane → cluster)
cd ../dev-environment
task clean

# Or clean only platform resources (keeps Crossplane and cluster)
task clean-platform
```

**Note:** The `clean` task follows the correct dependency order:
1. Cleans platform XRDs and Compositions first
2. Uninstalls Crossplane (CRDs can now be deleted)
3. Deletes Kind cluster and containers

### Taskfile Structure

The project uses modular Taskfiles organized by concern:

- `dev-environment/Taskfile.yaml`: Main orchestrator with dotenv for shared variables
- `dev-environment/vars.yaml`: Shared variables (versions, cluster name, GCP project)
- `dev-environment/utils/Taskfile.yaml`: Shared utility tasks (auth checks, etc.)
- `dev-environment/dependencies/Taskfile.yaml`: Dependency management (Docker, Kind, kubectl, Helm)
- `dev-environment/kind/Taskfile.yaml`: Kind cluster lifecycle
- `dev-environment/crossplane/Taskfile.yaml`: Crossplane installation and management
- `dev-environment/crossplane-gcp/Taskfile.yaml`: GCP provider configuration
- `dev-environment/github/Taskfile.yaml`: GitHub Actions service account setup
- `platform/Taskfile.yml`: Platform installation and testing

**Shared Variables:**
All Taskfiles use variables from `dev-environment/vars.yaml` to ensure consistency:
- `CROSSPLANE_VERSION=v2.0.2`
- `CLUSTER_NAME=meshifi-dev`
- `GCP_PROJECT_ID=meshifi-platform` (can be overridden)

Run `task --list` in any directory to see available tasks.

## Working with Compositions

### Composition Pipeline Steps

Compositions in `platform/core/compositions/` follow this pattern:

1. **pull-extra-resources**: Fetch referenced resources (e.g., DataDomain)
2. **validate-data-domain**: Validate cross-resource references
3. **create-datasets**: Conditionally create BigQuery datasets based on spec flags
4. **create-sa-and-bindings**: Create service account and IAM bindings for datasets
5. **automatically-detect-readiness**: Mark composite resource as ready when all managed resources are healthy

### Key Template Variables

When editing compositions, these variables are available in Go templates:

- `$.observed.composite.resource.metadata.name`: Resource name
- `$.observed.composite.resource.metadata.namespace`: Resource namespace
- `$.observed.composite.resource.spec.*`: User-provided spec fields
- `$.context["apiextensions.crossplane.io/extra-resources"]`: Referenced resources

### Naming Conventions

- **Kubernetes resources**: Use hyphens (e.g., `my-data-product`)
- **BigQuery datasets**: Use underscores (e.g., `my_data_product_raw`)
- **External names**: Use `crossplane.io/external-name` annotation for GCP resource names
- **Labels**: Use `meshifi.io/data-product` and `meshifi.io/data-domain` for tracking

## Testing and Debugging

### Debugging Crossplane Resources

```bash
# Check composite resource status
kubectl describe dataproduct <name> -n <namespace>

# Check managed resources (what Crossplane created)
kubectl get managed

# Check specific resource types
kubectl get dataset.bigquery.gcp.m.upbound.io
kubectl get serviceaccount.cloudplatform.gcp.m.upbound.io

# View events for troubleshooting
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

### GCP Provider Debugging

```bash
cd dev-environment/crossplane-gcp
task debug-provider-config    # Shows provider status and events

# Check provider installation
kubectl get providers

# Check provider configuration
kubectl get providerconfigs
```

### Common Issues

- **CRD version conflicts**: Run `task reinstall-crossplane` to clean CRDs and reinstall
- **GCP authentication errors**: Ensure `GCP_PROJECT_ID` is set and `gcloud auth login` completed
- **Provider not healthy**: Check provider pods in `crossplane-system` namespace

## CI/CD

### GitHub Workflow

The repository includes a validation workflow (`.github/workflows/validate.yml`) that:
- Sets up a Kind cluster
- Installs Crossplane and required functions
- Installs and tests the Meshifi platform
- Runs on pushes and PRs to `main` and `develop` branches

**Environment Variables:**
- `GCP_PROJECT_ID`: Set as a repository secret or defaults to `meshifi-platform`
  - Required for GCP provider setup and resource provisioning
  - Configure in GitHub Settings → Secrets and variables → Actions

The workflow validates that compositions work correctly without requiring actual GCP credentials (resources will be created but not provisioned).

### GitHub Actions Service Account Setup

For full GCP integration in GitHub Actions (to actually provision resources in GCP):

1. **Create the service account:**
   ```bash
   export GCP_PROJECT_ID=your-project-id
   cd dev-environment/github
   task setup
   ```

2. **Add secrets to GitHub repository:**
   - `GCP_SA_KEY`: Service account key JSON (from `github-sa-key.json`)
   - `GCP_PROJECT_ID`: Your GCP project ID

3. **Clean up local key file:**
   ```bash
   task delete-key-file
   ```

See `dev-environment/github/README.md` for detailed setup instructions.

**Assigned IAM Roles:**
- `roles/resourcemanager.projectIamAdmin` - Manage IAM policies
- `roles/bigquery.admin` - Manage BigQuery resources
- `roles/iam.serviceAccountAdmin` - Create service accounts
- `roles/iam.serviceAccountKeyAdmin` - Manage service account keys
- `roles/secretmanager.admin` - Manage secrets
- `roles/container.clusterAdmin` - Manage GKE clusters (future)
- `roles/compute.admin` - Manage compute resources (future)

## File Locations

- **Platform definitions**: `platform/core/`
  - XRDs: `platform/core/xrds/`
  - Compositions: `platform/core/compositions/`
  - Functions: `platform/core/functions.yaml`
- **Examples**: `platform/examples/`
- **Development setup**: `dev-environment/`
- **Documentation**: `docs/`
  - Design docs: `docs/design-infra.md`, `examples/01-basic-infra/docs/index.md`
  - Development guide: `docs/DEVELOPMENT.md`
  - Taskfile structure: `docs/TASKFILE_STRUCTURE.md`

## Key Design Principles

1. **Simplicity First**: Keep user-facing APIs minimal and intuitive
2. **Extensibility**: Design for future additions without breaking changes
3. **GitOps-Native**: All resources are declarative YAML suitable for version control
4. **Medallion Architecture**: Support raw/cleaned/curated dataset pattern by default
5. **Secure by Default**: Automatic service account and IAM permission management
