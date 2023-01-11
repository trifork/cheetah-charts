.PHONY: docs

docs:
	@docker run --rm --volume "$(PWD):/helm-docs" -u $(shell id -u) \
		jnorwood/helm-docs:v1.11.0 --sort-values-order file --chart-search-root charts/
