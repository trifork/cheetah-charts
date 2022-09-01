# cheetah-charts

[![Chart linting and testing](https://github.com/trifork/cheetah-charts/actions/workflows/helm-lint.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/helm-lint.yaml)
[![Release Helm charts to GCS](https://github.com/trifork/cheetah-charts/actions/workflows/helm-ci.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/helm-ci.yaml)

Repository containing the source code for different Helm charts.

## Usage

We use the Helm GCS plugin, so this must be installed:

```bash
helm plugin install https://github.com/hayorov/helm-gcs --version 0.3.19
```

To access the charts, you must have a Google Cloud Service Account configuration in json-format.
Add the repository and list the charts:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="<service-account-config>.json"
helm repo add cheetah-charts gs://cheetah-helm
helm search repo cheetah-charts
```

## Development

Linting will run on pull-requests to the main branch.
After pushing/merging to the main branch, charts that have changed version, will be packaged and pushed to GCS.

### Local testing

```shell
docker run -it --network host --workdir=/data --rm --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.5.0 
ct lint --config .github/ct-config.yaml # linting
helm template my-test <CHART_DIR> -f <CHART_DIR>/ci/example.yaml > output.yaml # manual test

```
