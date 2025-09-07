# Meshifi Examples

This directory contains example configurations for testing and learning how to use the Meshifi platform.

## Available Examples

### Data Domain Example

- **data-domain.yaml**: A complete example of a DataDomain resource that demonstrates the basic structure and configuration options.

**Example Configuration:**

```yaml
apiVersion: meshifi.io/v1alpha1
kind: DataDomain
metadata:
  name: example-domain
  namespace: default
spec:
  description: "Example data domain for demonstration"
  owner: "data-team@example.com"
  tags:
    - "example"
    - "demo"
  metadata:
    version: "1.0.0"
    createdBy: "meshifi-examples"
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
   kubectl apply -f examples/data-domain.yaml
   ```

2. **Check the resource**:

   ```bash
   kubectl get datadomains
   kubectl describe datadomain example-domain
   ```

3. **Verify created resources**:

   ```bash
   kubectl get configmaps -l meshifi.io/type
   ```

4. **Clean up**:
   ```bash
   kubectl delete -f examples/data-domain.yaml
   ```

## Expected Outcomes

When you apply the example DataDomain:

1. **DataDomain Resource**: A custom resource of type `DataDomain` will be created
2. **ConfigMaps**: The composition will create ConfigMaps with the `meshifi.io/type` label
3. **Status**: The resource should reach a "Ready" state within 60 seconds

## Troubleshooting

### Common Issues

**Resource doesn't become ready:**

- Check Crossplane logs: `kubectl logs -n crossplane-system`
- Verify composition is applied: `kubectl get compositions`
- Check for errors: `kubectl describe datadomain example-domain`

**ConfigMaps not created:**

- Ensure the composition is properly installed
- Check the composition status: `kubectl describe composition v1alpha1-data-domain`
- Verify the function is available: `kubectl get functions`

**Cleanup issues:**

- Check for finalizers: `kubectl get datadomain example-domain -o yaml`
- Force delete if needed: `kubectl delete datadomain example-domain --force --grace-period=0`

## Future Examples

Planned examples for future releases:

- **Data Product Examples**: Complete data product configurations
- **Multi-Domain Setup**: Cross-domain data mesh configurations
- **Infrastructure Examples**: Examples with cloud provider integrations
- **Advanced Configurations**: Complex scenarios with multiple resources

## Contributing Examples

To add new examples:

1. Create a new YAML file in this directory
2. Follow the naming convention: `kebab-case-description.yaml`
3. Include comprehensive comments in the YAML
4. Update this README with documentation
5. Test the example with `task test` workflow
