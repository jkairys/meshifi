# Taskfile Structure Documentation

This document explains the modular Taskfile structure used in the Meshifi project.

## Overview

The project uses a modular Taskfile approach where separate taskfiles manage different aspects of the development environment and platform.

## File Structure

```
dev-environment/
├── Taskfile.yaml                   # Main orchestrator
├── vars.yaml                       # Shared variables (versions, config)
├── utils/
│   └── Taskfile.yaml              # Shared utility tasks
├── dependencies/
│   └── Taskfile.yaml              # Dependency management
├── kind/
│   ├── Taskfile.yaml              # Kind cluster management
│   └── kind-config.yaml           # Kind cluster configuration
├── crossplane/
│   └── Taskfile.yaml              # Crossplane core management
├── crossplane-gcp/
│   ├── Taskfile.yaml              # GCP provider management
│   ├── provider-config.yaml       # GCP provider configuration
│   └── providers/                 # GCP provider definitions
│       ├── bigquery.yaml
│       ├── cloudplatform.yaml
│       └── iam.yaml
└── github/
    └── Taskfile.yaml              # GitHub Actions setup

platform/
└── Taskfile.yml                   # Meshifi platform management
```

## Taskfile Components

### 1. dev-environment/Taskfile.yaml (Main Orchestrator)

The main development environment Taskfile provides high-level commands that delegate to specialized sub-task files:

**Key Features:**

- Orchestrates the complete development environment setup
- Provides convenient aliases for common operations
- Manages dependencies, cluster, and Crossplane installation
- Includes cleanup and troubleshooting tasks

**Main Tasks:**

- `setup` - Complete environment setup (dependencies + cluster + Crossplane)
- `install-deps` - Install all required dependencies
- `create-cluster` - Create Kind cluster
- `install-crossplane` - Install Crossplane
- `clean` - Clean up everything (platform → Crossplane → cluster)
- `clean-platform` - Clean up Meshifi platform resources only
- `force-clean` - Force remove all containers and clusters
- `help` - Show all available tasks

**Configuration:**

- Uses `dotenv: ['vars.yaml']` to load shared variables
- Includes platform, utils, and component Taskfiles

### 2. dev-environment/vars.yaml (Shared Variables)

Central configuration file that defines common variables used across all Taskfiles.

**Variables Defined:**

- `CLUSTER_NAME` - Kind cluster name (default: meshifi-dev)
- `KIND_VERSION` - Kind version (default: v0.20.0)
- `KUBECTL_VERSION` - kubectl version (default: v1.28.0)
- `CROSSPLANE_VERSION` - Crossplane version (default: v2.0.2)
- `GCP_PROJECT_ID` - GCP project ID (default: meshifi-platform)

**Format:**

Uses dotenv format (KEY=value) for Task compatibility:
```bash
CLUSTER_NAME=meshifi-dev
CROSSPLANE_VERSION=v2.0.2
GCP_PROJECT_ID=meshifi-platform
```

**Benefits:**

- Single source of truth for versions
- Easy to update versions across all Taskfiles
- Can be overridden by environment variables
- Prevents version conflicts between Taskfiles

### 3. dev-environment/utils/Taskfile.yaml (Shared Utilities)

Provides reusable utility tasks used by multiple Taskfiles to eliminate code duplication.

**Tasks:**

- `check-gcloud-auth` - Validate gcloud CLI installation and authentication
- `check-cluster-accessible` - Verify Kubernetes cluster accessibility
- `check-required-var` - Validate required environment variables are set
- `enable-gcp-apis` - Enable required GCP APIs for a project
- `assign-iam-roles` - Assign IAM roles to service accounts

**Usage:**

Tasks are accessed via the `utils:` prefix from any included Taskfile:
```bash
task utils:check-gcloud-auth
task utils:check-cluster-accessible
```

**Benefits:**

- Eliminates duplicate authentication checks
- Consistent error messages across Taskfiles
- Centralized GCP operations
- Easy to maintain and update common logic

### 4. dev-environment/dependencies/Taskfile.yaml

Manages all external dependencies required for the project.

**Tasks:**

- `install` - Install all dependencies (macOS/Linux)
- `install-macos` - macOS-specific installation
- `install-linux` - Linux-specific installation
- `install-task` - Install Task runner
- `check` - Verify all dependencies are installed
- `check-*` - Individual dependency checks

**Dependencies Managed:**

- Docker
- Kind
- kubectl
- Helm
- Crossplane CLI
- Task runner

### 5. dev-environment/kind/Taskfile.yaml

Handles Kind cluster lifecycle management.

**Tasks:**

- `create` - Create Kind cluster
- `delete` - Delete Kind cluster
- `info` - Show cluster information
- `kubeconfig` - Show kubeconfig
- `check-kind` - Verify Kind installation

**Features:**

- Automatic cluster creation with configuration
- Clean deletion with container cleanup
- Cluster status reporting

### 6. dev-environment/crossplane/Taskfile.yaml

Manages Crossplane core installation and configuration.

**Tasks:**

- `install` - Install Crossplane using Helm
- `uninstall` - Uninstall Crossplane from cluster
- `clean-crds` - Clean up problematic Crossplane CRDs
- `status` - Check Crossplane status
- `logs` - Show Crossplane logs
- `help` - Show available Crossplane tasks

**Features:**

- Helm-based installation with version management
- Uses shared `CROSSPLANE_VERSION` from vars.yaml
- CRD cleanup for version conflicts
- Health checking and status monitoring
- Debugging support with logs
- Graceful error handling for missing clusters

**Variables:**

- Inherits `CROSSPLANE_VERSION` from vars.yaml (v2.0.2)

### 7. dev-environment/crossplane-gcp/Taskfile.yaml

Manages GCP provider installation and configuration for Crossplane.

**Tasks:**

- `deps` - Check required variables are set
- `uninstall-gcp-provider` - Uninstall existing GCP providers
- `install-gcp-providers` - Install upjet GCP providers from Upbound registry
- `create-gcp-key` - Create GCP service account key and store in Secret Manager
- `configure-gcp-provider` - Configure GCP provider with credentials
- `setup` - Complete GCP setup (uninstall + install + configure)
- `debug-provider-config` - Debug GCP provider config status and events

**Features:**

- Upbound registry provider management
- GCP service account and key management
- Secret Manager integration for credential storage
- Provider configuration with proper authentication
- Comprehensive debugging and status checking
- Support for multiple GCP provider versions
- Automatic cleanup of conflicting providers
- Uses shared `utils:check-gcloud-auth` for authentication validation

**Variables:**

- `CROSSPLANE_SERVICE_ACCOUNT_EMAIL` - GCP service account email
- `GCP_SECRET_NAME` - Name of the secret in GCP Secret Manager
- Inherits `GCP_PROJECT_ID` from vars.yaml (can be overridden)

**Dependencies:**

- Requires `GCP_PROJECT_ID` environment variable or vars.yaml default
- Requires `gcloud` CLI to be installed and authenticated
- Requires Crossplane to be installed first
- Uses `utils:check-gcloud-auth` for validation

### 8. dev-environment/github/Taskfile.yaml

Manages GitHub Actions service account setup for CI/CD workflows.

**Tasks:**

- `deps` - Check required variables are set
- `create-service-account` - Create GitHub Actions service account
- `create-key` - Create and download service account key
- `delete-key-file` - Delete local key file
- `setup` - Complete GitHub Actions setup
- `delete-service-account` - Delete GitHub Actions service account
- `info` - Show service account information

**Features:**

- Automated service account creation with proper IAM roles
- Service account key management
- Local key file handling
- Uses shared `utils:check-gcloud-auth` for authentication validation

**Variables:**

- `GITHUB_SERVICE_ACCOUNT_NAME` - Service account name (default: github)
- `GITHUB_SERVICE_ACCOUNT_EMAIL` - Computed service account email
- `KEY_FILE` - Local key file path (default: ./github-sa-key.json)
- Inherits `GCP_PROJECT_ID` from vars.yaml

### 9. platform/Taskfile.yml

Handles Meshifi platform installation and testing.

**Tasks:**

- `install` - Install Meshifi core package
- `uninstall` - Uninstall Meshifi package
- `status` - Check package status
- `test` - Test with example resources
- `cleanup-test` - Clean up test resources

**Features:**

- CRD and composition management
- Example resource testing
- Package status monitoring

## Usage Examples

### Complete Setup

```bash
# Full development environment setup
cd dev-environment
task setup

# Install Meshifi platform
cd ../platform
task install

# Test with example
kubectl apply -f examples/data-domain.yaml
```

### GCP Provider Setup

```bash
# Set GCP project ID
export GCP_PROJECT_ID=your-project-id

# Complete GCP setup (requires gcloud authentication)
cd dev-environment/crossplane-gcp
task setup

# Or step by step:
task create-gcp-key      # Create service account and store key in Secret Manager
task install-gcp-providers  # Install GCP providers
task configure-gcp-provider # Configure provider with credentials
```

### Individual Components

```bash
# Install dependencies only
cd dev-environment
task install-deps

# Create cluster only
task create-cluster

# Install Crossplane only
task install-crossplane

# Install Meshifi platform only
cd ../platform
task install
```

### Sub-task File Access

```bash
# List dependency tasks
cd dev-environment/dependencies
task --list

# List Kind tasks
cd ../kind
task --list

# List Crossplane tasks
cd ../crossplane
task --list

# List GCP provider tasks
cd ../crossplane-gcp
task --list

# List platform tasks
cd ../../platform
task --list
```

### Direct Sub-task File Usage

```bash
# Use dependency taskfile directly
cd dev-environment
task --taskfile dependencies/Taskfile.yaml install

# Use Kind taskfile directly
task --taskfile kind/Taskfile.yaml create

# Use Crossplane taskfile directly
task --taskfile crossplane/Taskfile.yaml status

# Use GCP provider taskfile directly
task --taskfile crossplane-gcp/Taskfile.yaml setup

# Use platform taskfile directly
cd ../platform
task --taskfile Taskfile.yml test
```

### Cleanup Workflow

The cleanup tasks follow a specific dependency order to ensure resources are properly removed:

```bash
# Complete cleanup (recommended)
cd dev-environment
task clean

# This executes in order:
# 1. clean-platform    - Removes platform XRDs, Compositions, and sample resources
# 2. crossplane:uninstall - Removes Crossplane (and remaining CRDs)
# 3. kind:delete       - Deletes the Kind cluster and containers
```

**Cleanup Order Details:**

1. **Platform Cleanup First** (`clean-platform`):
   - Deletes any DataDomain/DataProduct sample resources
   - Removes Compositions (data-domain-composition, data-product-composition)
   - Removes XRDs (datadomains.meshifi.io, dataproducts.meshifi.io)
   - This prevents CRD deletion hangs by removing dependent resources first

2. **Crossplane Uninstall** (`crossplane:uninstall`):
   - Uninstalls Crossplane Helm release
   - Deletes crossplane-system namespace
   - Cleans up Crossplane CRDs
   - Now succeeds because platform XRDs are already gone

3. **Cluster Deletion** (`kind:delete`):
   - Deletes the Kind cluster
   - Removes any remaining Docker containers
   - Cleans up Docker networks

**Individual Cleanup Tasks:**

```bash
# Clean only platform resources (keeps Crossplane and cluster)
task clean-platform

# Force clean everything (aggressive, use if normal clean fails)
task force-clean
```

**Why Order Matters:**

The cleanup order is critical because:
- Crossplane CRDs have finalizers that prevent deletion while resources using them exist
- Deleting Crossplane before platform XRDs causes hangs on CRD cleanup
- Platform XRDs must be deleted before Crossplane CRDs
- Sample resources must be deleted before XRDs they depend on

## Benefits of This Structure

### 1. **Modularity**

- Each taskfile focuses on a specific concern
- Easy to maintain and update individual components
- Clear separation of responsibilities

### 2. **Reusability**

- Sub-task files can be used independently
- Tasks can be composed in different ways
- Easy to extend with new functionality

### 3. **Maintainability**

- Smaller, focused files are easier to understand
- Changes to one component don't affect others
- Clear dependencies between components

### 4. **Flexibility**

- Can run individual components as needed
- Easy to skip certain steps in development
- Supports different deployment scenarios

### 5. **Developer Experience**

- Clear help commands for each component
- Intuitive task names and descriptions
- Consistent command structure across files

## Migration from Monolithic Taskfile

The new structure provides better organization:

- Clear separation between development environment and platform concerns
- Modular taskfiles for different components
- Consistent command-line interface across components
- Better maintainability and extensibility

## Adding New Tasks

### To a Sub-task File

1. Add the task to the appropriate sub-task file
2. Update the help task if needed
3. Test the task independently

### To the Main Taskfile

1. Add a delegation task that calls the appropriate sub-task file
2. Update the help task to include the new task
3. Consider if the task should be in a sub-task file instead
4. Ensure the task follows the directory structure (dev-environment vs platform)

## Best Practices

1. **Keep tasks focused** - Each task should have a single responsibility
2. **Use descriptive names** - Task names should clearly indicate their purpose
3. **Include help** - Every taskfile should have a help task
4. **Document dependencies** - Use `deps` to clearly show task relationships
5. **Provide summaries** - Use `summary` to explain what tasks do
6. **Test independently** - Each sub-task file should work on its own
7. **Use shared variables** - Update vars.yaml instead of duplicating version numbers
8. **Use shared utilities** - Call `utils:` tasks instead of duplicating common checks
9. **Follow cleanup order** - Always clean platform resources before infrastructure

## Troubleshooting

### Task Not Found

- Check if you're using the correct taskfile
- Use `task --list` to see available tasks
- Use help commands to explore sub-task files

### Delegation Issues

- Ensure sub-task files exist and are valid
- Check that task names match between files
- Verify file paths are correct

### Dependency Problems

- Check that prerequisite tasks are completed
- Use individual component tasks to isolate issues
- Review task dependencies in the main Taskfile

## GCP Provider Considerations

### Prerequisites

Before using the GCP provider tasks, ensure you have:

1. **GCP Project**: A valid GCP project with billing enabled
2. **gcloud CLI**: Installed and authenticated with appropriate permissions
3. **Required APIs**: Cloud Resource Manager and Secret Manager APIs enabled
4. **Permissions**: Project IAM Admin role or equivalent permissions

### Environment Variables

The GCP provider tasks require the following environment variable:

```bash
export GCP_PROJECT_ID=your-gcp-project-id
```

### Service Account Management

The GCP provider tasks automatically:

- Create a service account named `crossplane`
- Generate and manage service account keys
- Store credentials securely in GCP Secret Manager
- Configure proper IAM roles and permissions

### Security Considerations

- Service account keys are stored in GCP Secret Manager, not locally
- Keys are automatically rotated when recreated
- Minimal required permissions are assigned
- Credentials are cleaned up from local temporary files

### Troubleshooting GCP Provider

Common issues and solutions:

1. **Authentication errors**: Ensure `gcloud auth login` is completed
2. **Permission denied**: Check IAM roles and project access
3. **API not enabled**: Run `gcloud services enable` for required APIs
4. **Provider not healthy**: Use `task debug-provider-config` for detailed status

This modular structure provides a clean, maintainable, and flexible approach to managing the Meshifi development environment.
