on:
  push:
    branches:
      - main
name: Gateway Nginx Config to ConfigMap
jobs:
  convert_config:
    name: JSON to ConfigMap
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Converting JSON config to ConfigMaps
        uses: RedHatInsights/gateway-config-actions/convert-config@main
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch_name: <BRANCH_NAME>
