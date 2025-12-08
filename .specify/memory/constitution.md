<!--
SYNC IMPACT REPORT
==================
Version change: 0.0.0 → 1.0.0
Bump type: MAJOR (initial ratification of project constitution)

Added sections:
- 7 Core Principles (Platform-Product Separation, Domain Boundaries, Contract Stability,
  Observable Status, Environment Portability, Minimum Viable Implementation, Tidy Repository)
- Development Workflow section
- Taskfile Architecture section

Modified principles: N/A (initial version)
Removed sections: N/A (initial version)

Templates requiring updates:
- .specify/templates/plan-template.md ✅ (no updates needed - generic structure)
- .specify/templates/spec-template.md ✅ (no updates needed - generic structure)
- .specify/templates/tasks-template.md ✅ (no updates needed - generic structure)

Follow-up TODOs: None
-->

# Meshifi Constitution

## Core Principles

### I. Platform-Product Separation

The platform provisions data product infrastructure ONLY. It MUST NOT contain data product
business logic. The platform facilitates a clear separation between data platform concerns
and data product concerns.

**Rationale**: Data product teams should own their transformation logic, schemas, and business
rules. The platform provides the infrastructure substrate without coupling to product-specific
implementations.

### II. Domain Boundaries and Bounded Contexts

The platform MUST establish clear domain boundaries and bounded contexts. Data product creators
MUST be able to build and deploy at their own pace, independent of platform release cycles.

**Rationale**: Loose coupling between domains enables autonomous team velocity. Changes to one
data product MUST NOT require changes to other data products or the platform itself.

### III. Contract Stability

The platform MUST provide a stable contract to support deployed data products. New versions
of the platform MUST maintain backward compatibility with existing deployed data products.

**Enforcement**:
- Breaking changes to XRDs require a MAJOR version bump and migration documentation
- Compositions MUST support existing resource specifications indefinitely or provide
  automated migration paths
- API deprecations MUST be announced at least one minor version before removal

### IV. Observable Status

The platform MUST provide feedback to users in the form of resource health checks and status
conditions. Users MUST be able to determine the state of their data products without inspecting
underlying infrastructure.

**Implementation**:
- All composite resources MUST surface meaningful status conditions
- Error states MUST include actionable diagnostic information
- Health checks MUST propagate from managed resources to composite resources

### V. Environment Portability

The platform MUST maintain separation between the development environment (Kind cluster,
local Crossplane, associated credentials) and the platform itself. The dev environment and
prod environment MUST be interchangeable from the platform's perspective.

**Enforcement**:
- Platform manifests MUST NOT contain environment-specific configuration
- Environment-specific values MUST be injected via ProviderConfig or external secrets
- The same `platform/` artifacts MUST deploy to any conformant Kubernetes cluster

### VI. Minimum Viable Implementation

Features MUST NOT be added unless there is a strong, immediate need in the current
implementation. Favor the simplest solution that meets current requirements.

**Principles**:
- YAGNI (You Aren't Gonna Need It) is the default stance
- Speculative features require explicit justification
- Complexity MUST be justified by current, not future, requirements

### VII. Tidy Repository

The repository MUST remain clean and professional. Temporary testing scripts, debug artifacts,
and experimental code MUST NOT be committed to the repository.

**Enforcement**:
- Use `.gitignore` to exclude generated and temporary files
- Test fixtures belong in designated `examples/` or `tests/` directories
- One-off scripts MUST be deleted after use or promoted to proper tooling

## Development Workflow

Development follows a Taskfile-driven approach with clear separation of concerns:

- **Local development**: Uses Kind (Kubernetes in Docker) for fast iteration
- **Platform installation**: `task install` in `platform/` deploys XRDs, compositions, and functions
- **Verification**: `task verify` runs the complete validation workflow
- **Cleanup**: `task cleanup` tears down the environment cleanly

All development workflows MUST be reproducible via Taskfile commands.

## Taskfile Architecture

Taskfiles MUST follow patterns of modularity and loose coupling:

- **Reuse via imports**: Common functionality SHOULD be imported from shared Taskfiles
- **Single responsibility**: Each Taskfile SHOULD focus on one concern (dependencies, cluster, platform)
- **Shared variables**: Use `vars.yaml` for cross-cutting configuration
- **Idempotent tasks**: Tasks SHOULD be safe to run multiple times

## Governance

This constitution supersedes all other development practices for the Meshifi project.

**Amendment Process**:
1. Propose changes via pull request modifying this document
2. Changes require review and approval
3. Backward-incompatible governance changes require MAJOR version bump
4. All amendments MUST update the `Last Amended` date

**Compliance**:
- All PRs MUST verify compliance with these principles
- Reviewers SHOULD reference specific principles when requesting changes
- Use `CLAUDE.md` and project documentation for runtime development guidance

**Version**: 1.0.0 | **Ratified**: 2025-12-09 | **Last Amended**: 2025-12-09
