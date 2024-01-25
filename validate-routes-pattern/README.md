# GATEWAY Validate Routes Pattern
This will validate if the routes match pattern.

Usage:
```
on:
  pull_request:
    branches:
      - master
name: PR Workflow
jobs:
  validate_routes:
    name: Validate Routes Pattern
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Routes Pattern
        uses: RedHatInsights/gateway-config-actions/validate-routes-pattern@main
        with:
          routes_pattern: 'configs/**/*/routes.yml'
```