# GCP Setup Guide for Meshifi

This guide walks you through setting up Google Cloud Platform (GCP) infrastructure provisioning with Crossplane in your Meshifi development environment.

## Prerequisites

- A GCP account with billing enabled
- A GCP project (create one if you don't have one)
- Your Kind cluster with Crossplane already installed

## Step 1: GCP Console Setup

### 1.1 Enable Required APIs

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** > **Library**
4. Enable these APIs:
   - **Cloud Resource Manager API**
   - **Compute Engine API**
   - **Cloud SQL Admin API**
   - **Cloud Storage API**
   - **Identity and Access Management (IAM) API**
   - **Service Usage API**
   - **BigQuery API** (if using BigQuery)
   - **Pub/Sub API** (if using Pub/Sub)

### 1.2 Create Service Account

1. Go to **IAM & Admin** > **Service Accounts**
2. Click **Create Service Account**
3. Fill in the details:
   - **Name**: `crossplane-provider-gcp`
   - **Description**: `Service account for Crossplane GCP provider`
   - **ID**: `crossplane-provider-gcp` (auto-generated)

### 1.3 Assign Required Roles

For the service account, assign these roles:

**Minimum Required Roles:**

- **Project IAM Admin** (`roles/resourcemanager.projectIamAdmin`)
- **Service Account Admin** (`roles/iam.serviceAccountAdmin`)
- **Compute Instance Admin** (`roles/compute.instanceAdmin`)
- **Network Admin** (`roles/compute.networkAdmin`)
- **Storage Admin** (`roles/storage.admin`)

**Additional Roles (if using these services):**

- **BigQuery Admin** (`roles/bigquery.admin`)
- **Cloud SQL Admin** (`roles/cloudsql.admin`)
- **Pub/Sub Admin** (`roles/pubsub.admin`)
- **Kubernetes Engine Admin** (`roles/container.admin`)

### 1.4 Install and Authenticate gcloud CLI

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) if not already installed
2. Authenticate with your Google account:
   ```bash
   gcloud auth login
   ```
3. Set your default project (optional, but recommended):
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

### 1.5 Note Your Project ID

Make sure you know your GCP Project ID - you'll need this for the configuration.

## Step 2: Configure Environment Variables

Set the required environment variable:

```bash
export GCP_PROJECT_ID="your-gcp-project-id"
```

**Note**: You no longer need to manually create and download service account keys. The setup process will automatically create the service account and fetch the key using the gcloud CLI.

## Step 3: Install and Configure GCP Provider

### 3.1 Install GCP Provider

```bash
cd dev-environment
task setup-gcp
```

This will:

- Install the GCP provider for Crossplane
- Automatically create the service account (`crossplane-provider-gcp`)
- Assign all required roles to the service account
- Generate and download the service account key
- Configure Crossplane with the credentials
- Clean up the temporary key file

### 3.2 Verify Installation

Check that everything is working:

```bash
# Check provider status
kubectl get providers

# Check provider config
kubectl get providerconfigs

# Check GCP credentials secret
kubectl get secrets -n crossplane-system | grep gcp
```

## Step 4: Install GCP Compositions

Install the GCP-enabled compositions:

```bash
cd ../platform
task install
```

This will install the updated DataDomain XR with GCP support and the GCP composition.

## Step 5: Test GCP Resource Provisioning

### 5.1 Create a GCP Data Domain

Create a test data domain with GCP resources:

```bash
kubectl apply -f examples/gcp-data-domain.yaml
```

### 5.2 Monitor Resource Creation

Watch the resources being created:

```bash
# Watch the DataDomain
kubectl get datadomains -w

# Watch the GCP resources
kubectl get buckets,datasets,instances -w

# Check Crossplane logs
task logs
```

### 5.3 Verify in GCP Console

1. Go to your GCP Console
2. Check that the resources were created:
   - **Storage** > **Cloud Storage** (for buckets)
   - **BigQuery** (for datasets)
   - **Compute Engine** > **VM instances** (for compute instances)

## Step 6: Clean Up (Optional)

To clean up the test resources:

```bash
# Delete the DataDomain (this will delete all GCP resources)
kubectl delete datadomain analytics-domain

# Or delete everything
cd dev-environment
task clean
```

## Troubleshooting

### Common Issues

1. **Provider not healthy**: Check that the GCP provider is installed and the credentials are correct
2. **Permission denied**: Verify that the service account has the required roles
3. **API not enabled**: Make sure all required APIs are enabled in your GCP project
4. **Resource creation fails**: Check the Crossplane logs for detailed error messages

### Useful Commands

```bash
# Check provider status
kubectl describe provider provider-gcp

# Check provider config
kubectl describe providerconfig default

# Check Crossplane logs
kubectl logs -n crossplane-system -l app=crossplane

# Check specific resource status
kubectl describe datadomain analytics-domain
```

## Next Steps

Now that you have GCP infrastructure provisioning working, you can:

1. Create more complex compositions with multiple GCP services
2. Add support for other cloud providers (AWS, Azure)
3. Create data product compositions that use GCP resources
4. Implement governance and security policies

## Security Considerations

- Store your service account key file securely
- Consider using Workload Identity instead of service account keys for production
- Regularly rotate your service account keys
- Use least-privilege access for the service account roles
- Consider using separate service accounts for different environments
