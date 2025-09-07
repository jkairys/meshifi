# Taskfile Structure Documentation

This document explains the modular Taskfile structure used in the Meshifi project.

## Overview

The project uses a split Taskfile approach where the main `Taskfile.yml` orchestrates specialized sub-task files, each focused on a specific aspect of the development environment.

## File Structure

```
├── Taskfile.yml                    # Main orchestrator
├── Taskfile.dependencies.yml       # Dependency management
├── Taskfile.kind.yml              # Kind cluster management
├── Taskfile.crossplane.yml        # Crossplane management
└── Taskfile.meshifi.yml           # Meshifi package management
```

## Taskfile Components

### 1. Taskfile.yml (Main Orchestrator)

The main Taskfile provides high-level commands that delegate to specialized sub-task files:

**Key Features:**

- Orchestrates the complete development environment setup
- Provides convenient aliases for common operations
- Maintains backward compatibility with existing workflows
- Includes help commands for each sub-task file

**Main Tasks:**

- `setup` - Complete environment setup
- `dev` - Start development environment
- `clean` - Clean up everything
- `help` - Show all available tasks

### 2. Taskfile.dependencies.yml

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

### 3. Taskfile.kind.yml

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

### 4. Taskfile.crossplane.yml

Manages Crossplane installation and configuration.

**Tasks:**

- `install` - Install Crossplane
- `uninstall` - Uninstall Crossplane
- `status` - Check Crossplane status
- `logs` - Show Crossplane logs
- `port-forward` - Port forward for debugging

**Features:**

- Helm-based installation
- Provider management
- Health checking
- Debugging support

### 5. Taskfile.meshifi.yml

Handles Meshifi package installation and testing.

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
# Full environment setup
task setup

# Start development
task dev
```

### Individual Components

```bash
# Install dependencies only
task install-deps

# Create cluster only
task create-cluster

# Install Crossplane only
task install-crossplane

# Install Meshifi package only
task install-meshifi
```

### Sub-task File Access

```bash
# List dependency tasks
task deps-help

# List Kind tasks
task kind-help

# List Crossplane tasks
task crossplane-help

# List Meshifi tasks
task meshifi-help
```

### Direct Sub-task File Usage

```bash
# Use dependency taskfile directly
task --taskfile Taskfile.dependencies.yml install

# Use Kind taskfile directly
task --taskfile Taskfile.kind.yml create

# Use Crossplane taskfile directly
task --taskfile Taskfile.crossplane.yml status

# Use Meshifi taskfile directly
task --taskfile Taskfile.meshifi.yml test
```

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

The new structure maintains backward compatibility:

- All original task names still work
- Same command-line interface
- Same functionality, better organization

## Adding New Tasks

### To a Sub-task File

1. Add the task to the appropriate sub-task file
2. Update the help task if needed
3. Test the task independently

### To the Main Taskfile

1. Add a delegation task that calls the sub-task file
2. Update the help task to include the new task
3. Consider if the task should be in a sub-task file instead

## Best Practices

1. **Keep tasks focused** - Each task should have a single responsibility
2. **Use descriptive names** - Task names should clearly indicate their purpose
3. **Include help** - Every taskfile should have a help task
4. **Document dependencies** - Use `deps` to clearly show task relationships
5. **Provide summaries** - Use `summary` to explain what tasks do
6. **Test independently** - Each sub-task file should work on its own

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

This modular structure provides a clean, maintainable, and flexible approach to managing the Meshifi development environment.
