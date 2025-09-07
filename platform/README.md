# Meshifi Platform

This directory contains the core Meshifi platform components and management tasks. The platform is built using Crossplane and provides Kubernetes-native data mesh capabilities.

## Overview

The Meshifi platform consists of:

- **Core Package**: Crossplane compositions and custom resource definitions for data domains
- **Examples**: Sample configurations and test resources
- **Management Tasks**: Automated installation, testing, and cleanup workflows

## Quick Start

1. **Install the platform**:

   ```bash
   task install
   ```

2. **Test with examples**:

   ```bash
   task test
   ```

3. **Clean up test resources**:
   ```bash
   task cleanup-test
   ```

## Available Tasks

### Installation Tasks

#### `task install`

Installs the Meshifi platform by applying the core package components.

**What it does:**

- Applies CompositeResourceDefinitions (CRDs) from `core/xrds/`
- Applies Compositions from `core/compositions/`
- Sets up the data domain resource definitions

**Usage:**

```bash
task install
```

#### `task uninstall`

Uninstalls the Meshifi platform by removing all installed components.

**What it does:**

- Removes compositions from the cluster
- Removes CompositeResourceDefinitions
- Cleans up all platform resources

**Usage:**

```bash
task uninstall
```

### Package Management Tasks

#### `task install-package`

Installs a specific Meshifi package (used internally by install task).

**Parameters:**

- `PACKAGE`: The package name to install (e.g., "core")

**What it does:**

- Applies CRDs from the specified package directory
- Applies compositions from the specified package directory
- Provides detailed installation progress

**Usage:**

```bash
task install-package PACKAGE=core
```

#### `task uninstall-package`

Uninstalls a specific Meshifi package (used internally by uninstall task).

**Parameters:**

- `PACKAGE`: The package name to uninstall (e.g., "core")

**What it does:**

- Removes compositions from the specified package
- Removes CRDs from the specified package
- Provides cleanup confirmation

**Usage:**

```bash
task uninstall-package PACKAGE=core
```

### Testing Tasks

#### `task test`

Tests the Meshifi package by creating and validating example resources.

**What it does:**

- Applies the example data domain from `examples/data-domain.yaml`
- Waits for resources to become ready (60s timeout)
- Displays the status of created resources
- Shows created ConfigMaps with meshifi.io/type labels

**Dependencies:**

- Requires the platform to be installed (`task install`)

**Usage:**

```bash
task test
```

**Expected Output:**

- DataDomain resource status
- List of created ConfigMaps
- Confirmation of successful test

#### `task cleanup-test`

Cleans up test resources created during testing.

**What it does:**

- Removes all resources from the `examples/` directory
- Provides cleanup confirmation

**Usage:**

```bash
task cleanup-test
```

### Utility Tasks

#### `task help`

Shows all available tasks in the platform Taskfile.

**Usage:**

```bash
task help
```

## Directory Structure

```
platform/
├── core/                    # Core Crossplane package
│   ├── compositions/        # Crossplane compositions
│   │   └── v1alpha1-data-domain.yaml
│   ├── functions.yaml      # Function definitions
│   └── xrds/              # CompositeResourceDefinitions
│       └── data-domain.yaml
├── examples/               # Example configurations
│   ├── data-domain.yaml   # Example data domain resource
│   └── README.md          # Examples documentation
├── Taskfile.yml           # Platform management tasks
└── README.md             # This file
```

## Core Components

### CompositeResourceDefinitions (XRDs)

Located in `core/xrds/`, these define the custom resources that make up the Meshifi platform:

- **DataDomain**: Represents a logical data domain in the data mesh

### Compositions

Located in `core/compositions/`, these define how the custom resources are composed and what infrastructure they provision:

- **v1alpha1-data-domain**: Composition for creating data domain resources

### Functions

Located in `core/functions.yaml`, these define reusable transformation functions used in compositions.

## Examples

The `examples/` directory contains sample configurations for testing and learning:

- **data-domain.yaml**: A complete example of a data domain resource
- **README.md**: Documentation for the examples

## Development Workflow

1. **Set up development environment** (from project root):

   ```bash
   cd dev-environment
   task setup
   ```

2. **Install the platform**:

   ```bash
   cd ../platform
   task install
   ```

3. **Test the installation**:

   ```bash
   task test
   ```

4. **Verify resources**:

   ```bash
   kubectl get datadomains
   kubectl get configmaps -l meshifi.io/type
   ```

5. **Clean up when done**:
   ```bash
   task cleanup-test
   task uninstall
   ```

## Troubleshooting

### Common Issues

**Installation fails:**

- Ensure Crossplane is installed and running
- Check cluster connectivity: `kubectl cluster-info`
- Verify CRDs are applied: `kubectl get crd | grep meshifi`

**Test resources don't become ready:**

- Check Crossplane logs: `kubectl logs -n crossplane-system`
- Verify composition is applied: `kubectl get compositions`
- Check resource status: `kubectl describe datadomain example-domain`

**Cleanup issues:**

- Manually remove resources: `kubectl delete -f examples/`
- Check for finalizers: `kubectl get datadomain example-domain -o yaml`

### Getting Help

- List all tasks: `task help`
- Check task details: `task <task-name> --dry`
- View Crossplane status: `kubectl get all -n crossplane-system`
- Check resource status: `kubectl get datadomains,compositions,compositeresources`

## Integration with Development Environment

This platform integrates with the development environment setup:

- **Dependencies**: Requires Crossplane to be installed (handled by `dev-environment/task setup`)
- **Cluster**: Works with the Kind cluster created by the dev environment
- **Testing**: Can be tested alongside the development environment tasks

For complete setup instructions, see the main [README.md](../README.md) and [docs/DEVELOPMENT.md](../docs/DEVELOPMENT.md).
