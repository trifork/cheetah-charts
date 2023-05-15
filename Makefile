.PHONY: all docs lint

DOCKERINSTALLED := $(shell command -v docker 2> /dev/null)

all: docs lint

docs:
ifndef DOCKERINSTALLED
	@helm-docs --sort-values-order file --chart-search-root charts/
else
	@docker run --rm --volume "$(PWD):/helm-docs" -u $(shell id -u) \
		jnorwood/helm-docs:v1.11.0 --sort-values-order file --chart-search-root charts/
endif

lint:
ifndef DOCKERINSTALLED
	@ct lint --config .github/ct-config.yaml
else
	@docker run --rm --volume "$(PWD):/tmp" -u 1000 -w /tmp \
		quay.io/helmpack/chart-testing:v3.7.1 ct lint --config .github/ct-config.yaml
endif
