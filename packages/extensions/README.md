# Data Product Extensions

This directory contains Crossplane packages for data product capabilities and tooling integrations.

## Available Extensions

- **DBT**: Data modeling and transformation
- **Fivetran**: Data ingestion and ETL
- **Airbyte**: Open-source data integration
- **dbt Cloud**: Managed DBT service

## Extension Structure

Each extension follows the Crossplane package format and includes:
- Custom resource definitions for the tool
- Controllers for managing the tool lifecycle
- Compositions for common use cases
- Documentation and examples

## Creating Extensions

1. Use the Crossplane CLI to scaffold a new package
2. Implement the controller logic
3. Create resource compositions
4. Add documentation and examples
5. Test with the development cluster
