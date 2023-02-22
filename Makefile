.PHONY: all docs lint

all: docs lint

docs:
	@docker run --rm --volume "$(PWD):/helm-docs" -u $(shell id -u) \
		jnorwood/helm-docs:v1.11.0 --sort-values-order file --chart-search-root charts/

lint:
	@docker run --rm --volume "$(PWD):/tmp" -u 1000 -w /tmp \
		quay.io/helmpack/chart-testing:v3.7.1 ct lint --config .github/ct-config.yaml
