# GitHub Actions Service Account Setup

This directory contains tasks for setting up a GCP service account specifically for GitHub Actions CI/CD workflows.

## Overview

The GitHub Actions service account is used to authenticate GitHub workflows with GCP, allowing automated testing and deployment of the Meshifi platform.

## Prerequisites

- `gcloud` CLI installed and authenticated
- GCP project with billing enabled
- Permissions to create service accounts and assign IAM roles in the GCP project

## Quick Start

```bash
# Set your GCP project ID
export GCP_PROJECT_ID=your-project-id

# Create service account and generate key
task setup

# After adding the key to GitHub Secrets, clean up local file
task delete-key-file
```

## Available Tasks

### Setup Tasks

- **`task setup`** - Complete setup (creates service account and key)
- **`task create-service-account`** - Create service account and assign IAM roles
- **`task create-key`** - Create and download service account key

### Management Tasks

- **`task info`** - Show service account information and current status
- **`task delete-key-file`** - Delete local key file (for security)
- **`task delete-service-account`** - Delete the service account from GCP

### Utility Tasks

- **`task help`** - Show all available tasks
- **`task deps`** - Validate environment variables are set

## Service Account Configuration

### Service Account Details

- **Name**: `github`
- **Email**: `github@{GCP_PROJECT_ID}.iam.gserviceaccount.com`
- **Display Name**: "GitHub Actions"
- **Description**: "Service account for GitHub Actions CI/CD workflows"

### Assigned IAM Roles

The service account is granted the following roles:

1. **`roles/resourcemanager.projectIamAdmin`**
   - Manage IAM policies at the project level
   - Required for Crossplane to create service accounts

2. **`roles/bigquery.admin`**
   - Full access to BigQuery resources
   - Required for creating and managing BigQuery datasets

3. **`roles/iam.serviceAccountAdmin`**
   - Create and manage service accounts
   - Required for Crossplane service account creation

4. **`roles/iam.serviceAccountKeyAdmin`**
   - Create and manage service account keys
   - Required for Crossplane authentication

5. **`roles/secretmanager.admin`**
   - Manage secrets in Secret Manager
   - Required for storing Crossplane credentials

6. **`roles/container.clusterAdmin`**
   - Full access to GKE clusters (if needed)
   - Future-proofing for GKE deployments

7. **`roles/compute.admin`**
   - Manage Compute Engine resources (if needed)
   - Future-proofing for compute resources

### Enabled APIs

The setup automatically enables the following GCP APIs:

- Cloud Resource Manager API (`cloudresourcemanager.googleapis.com`)
- IAM API (`iam.googleapis.com`)
- Secret Manager API (`secretmanager.googleapis.com`)
- BigQuery API (`bigquery.googleapis.com`)

## Setting Up GitHub Actions

### 1. Create the Service Account

```bash
export GCP_PROJECT_ID=meshifi-platform
cd dev-environment/github
task setup
```

This will:
- Create the `github` service account
- Assign necessary IAM roles
- Enable required GCP APIs
- Generate a service account key file (`github-sa-key.json`)

### 2. Add Key to GitHub Secrets

1. Copy the key file contents:
   ```bash
   # macOS
   cat github-sa-key.json | pbcopy

   # Linux (with xclip)
   cat github-sa-key.json | xclip -selection clipboard

   # Or just display it
   cat github-sa-key.json
   ```

2. Add to GitHub repository:
   - Go to **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Name: `GCP_SA_KEY`
   - Value: Paste the entire JSON key content

3. Also add the project ID:
   - Click **New repository secret**
   - Name: `GCP_PROJECT_ID`
   - Value: Your GCP project ID (e.g., `meshifi-platform`)

### 3. Clean Up Local Key File

**IMPORTANT**: After adding the key to GitHub Secrets, delete the local file:

```bash
task delete-key-file
```

Never commit the key file to version control!

## Using in GitHub Workflows

The validation workflow (`.github/workflows/validate.yml`) is already configured to use these secrets:

```yaml
env:
  GCP_PROJECT_ID: ${{ secrets.GCP_PROJECT_ID || 'meshifi-platform' }}

steps:
  - name: Authenticate to GCP
    uses: google-github-actions/auth@v1
    with:
      credentials_json: ${{ secrets.GCP_SA_KEY }}
```

## Security Best Practices

1. **Never commit service account keys** to version control
2. **Delete local key files** after adding to GitHub Secrets
3. **Rotate keys regularly** by creating new keys and deleting old ones
4. **Use minimal permissions** - only grant roles that are absolutely necessary
5. **Monitor service account usage** through GCP IAM & Admin console
6. **Review IAM policies regularly** to ensure proper access control

## Troubleshooting

### Service Account Already Exists

If the service account already exists, the task will skip creation and only update IAM roles.

### Permission Denied Errors

Ensure you have the following permissions in the GCP project:
- `iam.serviceAccounts.create`
- `iam.serviceAccounts.setIamPolicy`
- `resourcemanager.projects.setIamPolicy`

### Key File Already Exists

If `github-sa-key.json` already exists locally, delete it first:

```bash
rm github-sa-key.json
task create-key
```

### Checking Service Account Status

View detailed information about the service account:

```bash
task info
```

This shows:
- Whether the service account exists
- All service account keys
- Assigned IAM roles

## Key Rotation

To rotate the service account key:

1. Create a new key:
   ```bash
   task create-key
   ```

2. Update GitHub Secret with the new key

3. Delete old keys (keep only the latest 2):
   ```bash
   gcloud iam service-accounts keys list --iam-account=github@{PROJECT_ID}.iam.gserviceaccount.com
   gcloud iam service-accounts keys delete {KEY_ID} --iam-account=github@{PROJECT_ID}.iam.gserviceaccount.com
   ```

4. Clean up local file:
   ```bash
   task delete-key-file
   ```

## Cleanup

To completely remove the GitHub Actions service account:

```bash
task delete-service-account
```

This will:
- Delete all service account keys
- Remove the service account from the GCP project
- Remove associated IAM policy bindings
