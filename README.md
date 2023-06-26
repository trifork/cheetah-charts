# Cheetah Charts

[![Chart linting](https://github.com/trifork/cheetah-charts/actions/workflows/lint.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/lint.yaml)
[![Release to GHCR](https://github.com/trifork/cheetah-charts/actions/workflows/release-oci.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/release-oci.yaml)
[![Release to Github releases](https://github.com/trifork/cheetah-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/trifork/cheetah-charts/actions/workflows/release.yaml)

Repository containing the source code for Helm charts used in the Trifork Data-platform.

## Usage

These helm charts are released to both GHCR (GitHub Container Registry) as OCI packages, and to GitHub releases as tar-ball assets.

### Install OCI Packages

For using the OCI packages, you need to log into the GHCR registry:

```bash
helm registry login ghcr.io/trifork/cheetah-charts
```

Log in using a GitHub account username and a PAT (Personal Access Token) that at least has the "read packages" permission.
Once you are logged in, you can start using the charts:

```bash
helm template releaseName oci://ghcr.io/trifork/cheetah-charts/<chartName> [--version x.x.x]
```

You can find the available versions under [packages](https://github.com/orgs/trifork/packages?repo_name=cheetah-charts).
Helm does not currently support searching for versions in OCI repositories.

### Install from GitHub releases

Currently, this is not possible as it requires a publicly hosted `index.yaml`.

## Contributing

Linting will run on pull-requests to the main branch, which also tests that documentation is up to date.
Additionally, pull-requests will also create a pre-release to GitHub releases, which can be tested on a live cluster.

After pull-requests has been merged to the main branch, charts that have changed version will be packaged and released.

## Development
### Prerequisites
For convenience, this repository uses `make` for linting and generating docs. Most dev-boxes already have `make`, and can easily be installed if you don't. On Windows, using `chocolatey`, simply run:
```bash
choco install make
```

If you have docker installed on your system, the make commands will run inside docker, if you do not, they will require [`ct`](https://github.com/helm/chart-testing) and [`helm-docs`](https://github.com/norwoodj/helm-docs) for linting and docs generation, respectively.

### Linting and Docs

To run linting on your local machine, use `make lint` at the root of this repository.
This will make use of [`ct`](https://github.com/helm/chart-testing) - a CLI for linting and testing on a running Kubernetes cluster.

To update documentation from your local machine, use `make docs` at the root of this repository.
This will make use of [`helm-docs`](https://github.com/norwoodj/helm-docs) to generate documentation based in the `values.yaml` file in each chart.

### Local testing

It is possible to open an interactive shell with some pre-installed useful tools, by running:

```bash
docker run -it --network host --workdir=/data --rm --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.5.0
```

Unfortunately, this Docker container does not include `make`, so it is not possible to run the `make` commands mentioned above.

However, the other tools which are included in this shell, is very useful.
This includes tools such as `helm`, `ct`, and `kubectl`.

For example, to render out the full manifest from the `flink-job` Helm chart, run something like:

```bash
helm template my-test charts/flink-job -f charts/flink-job/ci/example-values.yaml --dependency-update > output.yaml
```

This will render the templates in `charts/flink-job` using values in `charts/flink-job/ci/example-values.yaml` and outputting them to `output.yaml` as a release called `my-test`.
The `--dependency-update` flag makes sure that local chart dependencies are up to date.
It is not required after having run it once.

If you get errors using `helm template`, often times it is because the generated manifests does not create valid YAML (most likely from indentation errors).
To make helm generate the template anyway, add `--debug` to the `helm template` command.

Sometimes Helm is not able to generate the template even with `--debug`.
When this happens, it is most likely due to a nil pointer exception.
One of these errors might look like the following:

> `Error: template: flink-job/templates/servicemonitor.yaml:1:14: executing "flink-job/templates/servicemonitor.yaml" at <.Values.metrics.servicemonitor.enabled>: nil pointer evaluating interface {}.enabled`

In this case it is caused by a spelling mistake in line `1` in `servicemonitor.yaml`.
I am trying to access `.Values.metrics.servicemonitor.enabled` instead of `.Values.metrics.servicemonitor.enabled`.
As I haven't defined the `servicemonitor` object in the values file, Helm (or rather, Go) errors out when I am trying to access the `enabled` key in the object.

Changing the reference from `.Values.metrics.servicemonitor.enabled` to `.Values.metrics.servicemonitor.enabled`, the `helm template` is successful again.

To run the linting command (the same included in `Makefile`), run:

```bash
ct lint --config .github/ct-config.yaml
```
