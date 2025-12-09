# Meshifi Examples

This directory contains example configurations for testing and learning how to use the Meshifi platform.

## Available Examples

### Data Product Example

- **data-product.yaml**: A complete example of a DataProduct resource that demonstrates BigQuery dataset provisioning.

**Example Configuration:**

```yaml
apiVersion: meshifi.io/v1alpha1
kind: DataProduct
metadata:
  name: sales-data
  namespace: default
spec:
  id: sales-data
  name: Sales Data
  description: "Example data product for demonstration"
  owner: "data-team@example.com"
  gcp:
    projectId: meshifi-platform
    region: us-central1
  datasets:
    raw: true
    cleaned: true
    curated: true
```

## Testing Workflow

### Quick Test

1. **Install the platform** (from platform directory):

   ```bash
   task install
   ```

2. **Run the test**:

   ```bash
   task test
   ```

3. **Clean up**:
   ```bash
   task cleanup-test
   ```

### Manual Testing

1. **Apply the example**:

   ```bash
   kubectl apply -f examples/data-product.yaml
   ```

2. **Check the resource**:

   ```bash
   kubectl get dataproducts
   kubectl describe dataproduct sales-data
   ```

3. **Verify created resources**:

   ```bash
   kubectl get datasets
   kubectl get serviceaccounts -l meshifi.io/data-product
   ```

4. **Clean up**:
   ```bash
   kubectl delete -f examples/data-product.yaml
   ```

## Expected Outcomes

When you apply the example DataProduct:

1. **DataProduct Resource**: A custom resource of type `DataProduct` will be created
2. **BigQuery Datasets**: The composition will create datasets for each enabled tier (raw, cleaned, curated)
3. **Service Account**: A GCP service account will be created for the data product
4. **IAM Bindings**: The service account will be granted access to the datasets
5. **Status**: The resource should reach a "Ready" state within 60 seconds

## Troubleshooting

### Common Issues

**Resource doesn't become ready:**

- Check Crossplane logs: `kubectl logs -n crossplane-system`
- Verify composition is applied: `kubectl get compositions`
- Check for errors: `kubectl describe dataproduct sales-data`

**Datasets not created:**

- Ensure the composition is properly installed
- Check the composition status: `kubectl describe composition data-product-composition`
- Verify the function is available: `kubectl get functions`

**GCP resources not provisioned:**

- Verify GCP provider is configured: `kubectl get providerconfigs`
- Check provider status: `kubectl get providers`
- Ensure credentials are set up correctly

**Cleanup issues:**

- Check for finalizers: `kubectl get dataproduct sales-data -o yaml`
- Force delete if needed: `kubectl delete dataproduct sales-data --force --grace-period=0`

## Contributing Examples

To add new examples:

1. Create a new YAML file in this directory
2. Follow the naming convention: `kebab-case-description.yaml`
3. Include comprehensive comments in the YAML
4. Update this README with documentation
5. Test the example with `task test` workflow
