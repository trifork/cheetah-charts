# cheetah-flink-native

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

A Helm chart for handling Cheetah Data Platform Flink jobs

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../image-automation | image-automation | * |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| global | object | `{"image":{"repository":""},"imagePullSecrets":[]}` | Only used to decrease duplicate configuration of this chart, if image-automation is used as a sub chart. Overrides the local values if given |
| image.repository | string | `"flink"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.tag | string | `"main"` |  |
| image.sha | string | `""` |  |
| restartNonce | string | `nil` |  |
| serviceAccount.create | bool | `true` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.enabled | bool | `false` | Whether to expose the Flink UI |
| ingress.certType | string | `"staging"` |  |
| ingress.domain | string | `"flink.cheetah.trifork.dev"` |  |
| ingress.ingressClassName | string | `"nginx"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| flink.version | string | `"v1_14"` | Which Flink version to use |
| flink.savepoints.enabled | bool | `true` |  |
| flink.savepoints.generation | int | `0` | If the job changes too much, the savepoints of an earlier job cannot be used. The generation is added as a suffix to the savepoints directory, fixing the problem. Ignored if not greater than zero |
| flink.savepoints.endpoint | string | `"http://minio.minio.svc.cluster.local:9000"` |  |
| flink.state.backend | string | `"hashmap"` |  |
| flink.envVars | list | `[]` |  |
| flink.jobManager.replicas | int | `1` |  |
| flink.jobManager.metrics.enabled | bool | `true` |  |
| flink.jobManager.metrics.extraPorts[0].name | string | `"metrics"` |  |
| flink.jobManager.metrics.extraPorts[0].containerPort | int | `9249` |  |
| flink.jobManager.resource.memory | string | `"1Gb"` |  |
| flink.jobManager.resource.cpu | float | `0.5` |  |
| flink.jobManager.volumes | list | `[]` |  |
| flink.jobManager.volumeMounts | list | `[]` |  |
| flink.jobManager.podLabels | object | `{}` |  |
| flink.jobManager.podAnnotations | object | `{}` |  |
| flink.jobManager.additionalConfigs | object | `{}` | Any additional configuration passed to the jobmanager |
| flink.taskManager.replicas | int | `1` |  |
| flink.taskManager.volumes | list | `[]` |  |
| flink.taskManager.volumeMounts | list | `[]` |  |
| flink.taskManager.metrics.enabled | bool | `true` |  |
| flink.taskManager.metrics.extraPorts[0].name | string | `"metrics"` |  |
| flink.taskManager.metrics.extraPorts[0].containerPort | int | `9249` |  |
| flink.taskManager.metrics.extraPorts[0].protocol | string | `"TCP"` |  |
| flink.taskManager.resource.memory | string | `"512Mb"` |  |
| flink.taskManager.resource.cpu | float | `0.5` |  |
| flink.taskManager.podLabels | object | `{}` |  |
| flink.taskManager.podAnnotations | object | `{}` |  |
| flink.taskManager.additionalConfigs | object | `{}` | Any additional configuration passed to the taskmanager |
| flink.job.jarURI | string | `""` |  |
| flink.job.className | string | `""` |  |
| flink.job.args | list | `[]` |  |
| flink.job.state | string | `"running"` | Must be either: running or suspended |
| flink.job.upgradeMode | string | `"savepoint"` | Must be either: savepoint, last_state, stateless |
| flink.job.savepointTriggerNonce | string | `nil` |  |
| flink.job.initialSavepointPath | string | `nil` |  |
| flink.job.allowNonRestoredState | bool | `false` |  |
| flink.job.parallelism | int | `2` |  |
| flink.job.restartPolicy | string | `"Never"` |  |
| flink.job.volumes | list | `[]` |  |
| flink.job.volumeMounts | list | `[]` |  |
| flink.job.podLabels | object | `{}` |  |
| flink.job.podAnnotations."linkerd.io/inject" | string | `"disabled"` |  |
| flink.job.additionalConfigs | object | `{}` | Any additional configuration passed to the job |
| flink.flinkProperties."taskmanager.numberOfTaskSlots" | int | `1` |  |
| flink.flinkProperties."rest.flamegraph.enabled" | bool | `true` |  |
| flink.flinkProperties."execution.checkpointing.interval" | string | `"10 minutes"` |  |
| flink.flinkProperties."execution.checkpointing.timeout" | string | `"5 minutes"` |  |
| flink.flinkProperties."execution.checkpointing.min-pause" | string | `"10 minutes"` |  |
| image-automation | object | `{"enabled":false}` | Settings passed to the image-automation chart Image-automation is not possible when using image-sha as a tagging strategy |
| monitoring.enabled | bool | `false` |  |
| monitoring.podTargetLabels[0] | string | `"component"` |  |
| monitoring.podTargetLabels[1] | string | `"cluster"` |  |
| monitoring.flinkProperties."metrics.reporters" | string | `"prom"` |  |
| monitoring.flinkProperties."metrics.reporter.prom.class" | string | `"org.apache.flink.metrics.prometheus.PrometheusReporter"` |  |
| monitoring.flinkProperties."metrics.reporter.prom.port" | int | `9249` |  |
| monitoring.podMonitorSelectorLabels.prometheus | string | `"cluster-metrics"` |  |
| monitoring.podMetricsEndpoints[0].port | string | `"metrics"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)
