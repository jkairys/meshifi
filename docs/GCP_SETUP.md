# GCP Setup Guide for Meshifi

This guide walks you through setting up Google Cloud Platform (GCP) infrastructure provisioning with Crossplane in your Meshifi development environment.

## Prerequisites

- A GCP account with billing enabled
- A GCP project (create one if you don't have one)
- Your Kind cluster with Crossplane already installed
- gcloud CLI installed and authenticated

## Step 1: GCP Console Setup

### 1.1 Install and Authenticate gcloud CLI

1. Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) if not already installed
2. Authenticate with your Google account:
   ```bash
   gcloud auth login
   ```
3. Set your default project:
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

### 1.2 Enable Required APIs

The setup process will automatically enable the required APIs, but you can also enable them manually:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** > **Library**
4. Enable these APIs:
   - **Cloud Resource Manager API**
   - **Secret Manager API**
   - **Identity and Access Management (IAM) API**

**Note**: The automated setup will enable these APIs automatically, so manual enabling is optional.

## Step 2: Configure Environment Variables

Set the required environment variable:

```bash
export GCP_PROJECT_ID="your-gcp-project-id"
```

## Step 3: Install and Configure GCP Provider

### 3.1 Complete GCP Provider Setup

```bash
cd dev-environment/crossplane-gcp
task setup
```

This will:

- Uninstall any existing GCP providers
- Install the upjet GCP providers from Upbound registry
- Create the service account (`crossplane`) automatically
- Generate and store the service account key in GCP Secret Manager
- Configure Crossplane with the credentials from Secret Manager
- Clean up temporary files

### 3.2 Step-by-Step Setup (Alternative)

If you prefer to run the setup steps individually:

```bash
cd dev-environment/crossplane-gcp

# Create GCP service account and store key in Secret Manager
task create-gcp-key

# Install GCP providers from Upbound registry
task install-gcp-providers

# Configure provider with credentials
task configure-gcp-provider
```

### 3.3 Verify Installation

Check that everything is working:

```bash
# Check provider status
kubectl get providers

# Check provider config
kubectl get providerconfigs

# Check GCP credentials secret
kubectl get secrets -n crossplane-system | grep gcp

# Debug provider configuration (if needed)
task debug-provider-config
```

## Step 4: Install Meshifi Platform

Install the Meshifi platform with GCP compositions:

```bash
cd ../../platform
task install
```

This will install the Meshifi platform with GCP-enabled compositions.

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
cd ../dev-environment
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
5. **GCP_PROJECT_ID not set**: Ensure the environment variable is properly set

### Useful Commands

```bash
# Debug GCP provider configuration
cd dev-environment/crossplane-gcp
task debug-provider-config

# Check provider status
kubectl describe provider upbound-provider-gcp-iam

# Check provider config
kubectl describe providerconfig default

# Check Crossplane logs
cd ../dev-environment
task logs

# Check specific resource status
kubectl describe datadomain analytics-domain

# Check GCP service account
gcloud iam service-accounts list --filter="email:crossplane@$GCP_PROJECT_ID.iam.gserviceaccount.com"

# Check GCP Secret Manager
gcloud secrets list --filter="name:crossplane-gcp-key"
```

## Next Steps

Now that you have GCP infrastructure provisioning working, you can:

1. Create more complex compositions with multiple GCP services
2. Add support for other cloud providers (AWS, Azure)
3. Create data product compositions that use GCP resources
4. Implement governance and security policies

## Security Considerations

- Service account keys are automatically stored in GCP Secret Manager (not locally)
- Keys are automatically rotated when recreated
- Minimal required permissions are assigned to the service account
- Credentials are cleaned up from local temporary files
- Consider using Workload Identity instead of service account keys for production
- Use least-privilege access for the service account roles
- Consider using separate service accounts for different environments

## Key Features of the GCP Provider Setup

- **Automated Service Account Creation**: Creates `crossplane` service account automatically
- **Secret Manager Integration**: Stores credentials securely in GCP Secret Manager
- **Upbound Registry**: Uses the latest upjet GCP providers from Upbound
- **Automatic API Enablement**: Enables required GCP APIs automatically
- **Comprehensive Debugging**: Includes detailed debugging and status checking tools
- **Clean Credential Management**: No local key files, automatic cleanup
