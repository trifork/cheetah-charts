# cheetah-flink-native

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

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
| restartNonce | int | `0` | change this to force a restart of the job, see https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/ for more info |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| rbac.create | bool | `true` |  |
| rbac.additionalRules | list | `[]` | Additional rules to add to the role |
| ingress.enabled | bool | `false` | Whether to expose the Flink UI, The UI will be exposed under https://<.ingress.domain>/<release-namespace>/<release-name> by default |
| ingress.certType | string | `"staging"` |  |
| ingress.domain | string | `"flink.cheetah.trifork.dev"` |  |
| ingress.ingressClassName | string | `"nginx"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| ingress.uiPort | int | `8081` | the ui port. Ingress will hit the service on this port |
| vault.enabled | bool | `true` |  |
| vault.tlsSecret | string | `"vault-tls"` |  |
| vault.serviceaccount | string | `"default"` |  |
| flink.version | string | `"v1_14"` | Which Flink version to use |
| flink.configuration."s3.path-style-access" | string | `"true"` |  |
| flink.configuration."state.savepoints.dir" | string | `"s3p://flink/test-cheetah-flink-native/savepoints"` |  |
| flink.configuration."state.checkpoints.dir" | string | `"s3p://flink/test-cheetah-flink-native/checkpoints"` |  |
| flink.configuration."state.backend" | string | `"hashmap"` |  |
| flink.configuration.high-availability | string | `"org.apache.flink.kubernetes.highavailability.KubernetesHaServicesFactory"` |  |
| flink.configuration."high-availability.storageDir" | string | `"s3p://flink/test-cheetah-flink-native/ha"` |  |
| flink.configuration."execution.checkpointing.interval" | string | `"10 minutes"` |  |
| flink.configuration."execution.checkpointing.min-pause" | string | `"10 minutes"` |  |
| flink.configuration."execution.checkpointing.timeout" | string | `"5 minutes"` |  |
| flink.configuration."rest.flamegraph.enabled" | string | `"true"` |  |
| flink.configuration."taskmanager.numberOfTaskSlots" | string | `"2"` |  |
| flink.configuration."s3.access-key" | string | `"vault:secret/data/global/cheetah-flink-s3#accessKey"` |  |
| flink.configuration."s3.secret-key" | string | `"vault:secret/data/global/cheetah-flink-s3#secretKey"` |  |
| flink.configuration."s3.endpoint" | string | `"vault:secret/data/global/cheetah-flink-s3#endpoint"` |  |
| flink.jobManager.replicas | int | `1` |  |
| flink.jobManager.metrics.enabled | bool | `true` | enable metrics ports for jobManager |
| flink.jobManager.metrics.portName | string | `"metrics"` |  |
| flink.jobManager.metrics.port | int | `9249` |  |
| flink.jobManager.extraPorts | list | `[]` |  |
| flink.jobManager.resource.memory | string | `"1Gb"` |  |
| flink.jobManager.resource.cpu | float | `0.5` |  |
| flink.jobManager.volumes | list | `[]` |  |
| flink.jobManager.volumeMounts | list | `[]` |  |
| flink.jobManager.podLabels | object | `{}` |  |
| flink.jobManager.podAnnotations | object | `{}` |  |
| flink.jobManager.additionalConfigs | object | `{}` | Any additional configuration passed to the jobmanager |
| flink.jobManager.imagePullSecrets | list | `[]` |  |
| flink.jobManager.env | list | `[]` |  |
| flink.taskManager.replicas | int | `1` |  |
| flink.taskManager.volumes | list | `[]` |  |
| flink.taskManager.volumeMounts | list | `[]` |  |
| flink.taskManager.metrics.enabled | bool | `true` | enable metrics ports for taskManager |
| flink.taskManager.metrics.portName | string | `"metrics"` |  |
| flink.taskManager.metrics.port | int | `9249` |  |
| flink.taskManager.extraPorts | list | `[]` |  |
| flink.taskManager.resource.memory | string | `"1Gb"` |  |
| flink.taskManager.resource.cpu | float | `0.5` |  |
| flink.taskManager.podLabels | object | `{}` |  |
| flink.taskManager.podAnnotations."cluster-autoscaler.kubernetes.io/safe-to-evict" | string | `"true"` |  |
| flink.taskManager.additionalConfigs | object | `{}` | Any additional configuration passed to the taskmanager |
| flink.taskManager.imagePullSecrets | list | `[]` |  |
| flink.taskManager.env | list | `[]` |  |
| flink.job.jarURI | string | `""` | the path of the job jar |
| flink.job.className | string | `""` | the name of the job class |
| flink.job.args | list | `[]` |  |
| flink.job.state | string | `"running"` | Must be either: running or suspended |
| flink.job.upgradeMode | string | `"savepoint"` | Must be either: savepoint, last_state, stateless |
| flink.job.savepointTriggerNonce | int | `0` | change this to trigger a savepoint manually, see more here: https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/ |
| flink.job.initialSavepointPath | string | `""` | change this to force a manual recovery checkpoint, see more here: https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/ |
| flink.job.allowNonRestoredState | bool | `false` | If this is true, it will ignore the past checkpoints and start anew. Usefull if the job schema has changed. |
| flink.job.parallelism | int | `2` | How many jobs to run in parallel, see more here: https://nightlies.apache.org/flink/flink-docs-master/docs/dev/datastream/execution/parallel/ |
| flink.job.restartPolicy | string | `"Never"` |  |
| flink.job.volumes | list | `[]` |  |
| flink.job.volumeMounts | list | `[]` |  |
| flink.job.podLabels | object | `{}` |  |
| flink.job.podAnnotations."linkerd.io/inject" | string | `"disabled"` | Explicit disable Linkerd proxy injection, as it makes the job hang |
| flink.job.additionalConfigs | object | `{}` | Any additional configuration passed to the job |
| flink.job.topics | list | `[]` | Define the topics this job will consume must be defined as follows - name: <name of variable>   value: <name of topic> ie: - name: input-kafka-topic   value: "sourceTopic" - name: output-kafka-topic   value: "sinkTopic" |
| flink.flinkProperties."taskmanager.numberOfTaskSlots" | int | `1` |  |
| flink.flinkProperties."rest.flamegraph.enabled" | bool | `true` |  |
| flink.flinkProperties."execution.checkpointing.interval" | string | `"10 minutes"` |  |
| flink.flinkProperties."execution.checkpointing.timeout" | string | `"5 minutes"` |  |
| flink.flinkProperties."execution.checkpointing.min-pause" | string | `"10 minutes"` |  |
| image-automation | object | `{"enabled":false}` | Settings passed to the image-automation chart, Image-automation is not possible when using image-sha as a tagging strategy |
| monitoring.enabled | bool | `true` | Enable monitoring. Define flinkProperties to define the monitoring properties |
| monitoring.podTargetLabels[0] | string | `"component"` |  |
| monitoring.podTargetLabels[1] | string | `"cluster"` |  |
| monitoring.flinkProperties | object | `{"metrics.reporter.prom.class":"org.apache.flink.metrics.prometheus.PrometheusReporter","metrics.reporter.prom.port":9249,"metrics.reporters":"prom"}` | Define which monitoring system to use, See more here: https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/metric_reporters/ |
| monitoring.podMonitorSelectorLabels.prometheus | string | `"cluster-metrics"` |  |
| monitoring.podMonitorSelectorLabels.cheetah-monitoring | string | `"true"` |  |
| monitoring.podMetricsEndpoints[0].port | string | `"metrics"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
