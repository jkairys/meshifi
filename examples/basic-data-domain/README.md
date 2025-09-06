# Basic Data Domain Example

This example demonstrates how to create a basic data domain using the Meshifi core package.

## Prerequisites

- Kind cluster with Crossplane installed
- Meshifi core package deployed

## Steps

1. **Create a data domain**:
   ```bash
   kubectl apply -f data-domain.yaml
   ```

2. **Verify the domain was created**:
   ```bash
   kubectl get datadomains
   kubectl describe datadomain example-domain
   ```

3. **Create a data product**:
   ```bash
   kubectl apply -f data-product.yaml
   ```

4. **Verify the product was created**:
   ```bash
   kubectl get dataproducts
   kubectl describe dataproduct example-product
   ```

## Files

- `data-domain.yaml` - Data domain resource definition
- `data-product.yaml` - Data product resource definition
- `README.md` - This file

## Expected Output

After running the example, you should see:
- A data domain named "example-domain"
- A data product named "example-product" in the domain
- Both resources should be in "Ready" status
