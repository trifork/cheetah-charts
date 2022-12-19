# cheetah-charts

[![Chart linting and testing](https://github.com/trifork/cheetah-charts/actions/workflows/helm-lint.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/helm-lint.yaml)
[![Release Helm charts to GCS](https://github.com/trifork/cheetah-charts/actions/workflows/helm-release.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/helm-release.yaml)

Repository containing the source code for different Helm charts.

## Usage

These helm charts are released to both <ghcr.io> as OCI packages, and to a Google disk using the `helm-gcs` Helm plugin.

### Using Google Drive

For using the google disk the Helm GCS plugin must be installed:

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

### Using OCI Packages

For using the OCI packages, we need to log into the ghcr.io registry with a PAM token, that at least has the "read packages" permission:

```bash
helm registry login ghcr.io/trifork
```
Log in using your github account and PAM token

Once you are logged in, you can start using the charts

```bash
helm install releaseName oci://ghcr.io/trifork/cheetah-charts/<chartName> [--version x.x.x]
```

You can find the available versions under "packages" in the github repository. Helm does not currently support searching for versions in oci repositories.



## Development

Linting will run on pull-requests to the main branch.
After pushing/merging to the main branch, charts that have changed version, will be packaged and pushed to GCS.

### Local testing

```shell
docker run -it --network host --workdir=/data --rm --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.5.0 
ct lint --config .github/ct-config.yaml # linting
helm template my-test <CHART_DIR> -f <CHART_DIR>/ci/example.yaml > output.yaml # manual test

```
