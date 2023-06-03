# flink-job

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| image.repository | string | `"flink"` | Which image repository to use |
| image.tag | string | `"main"` | Which image tag to use |
| image.sha | string | `""` | Which image sha to use. If used, the `image.tag` is ignored |
| image.pullPolicy | string | `"Always"` | Which image pull policy to use |
| imagePullSecrets | list | `[]` | Image pull secrets. A list of `name: <secret-name>` |
| version | string | `"v1_15"` | Which Flink version to use |
| flinkConfiguration | object | `{"execution.checkpointing.interval":"10 minutes","execution.checkpointing.min-pause":"10 minutes","execution.checkpointing.timeout":"5 minutes","high-availability":"org.apache.flink.kubernetes.highavailability.KubernetesHaServicesFactory","kubernetes.jobmanager.cpu.limit-factor":"10.0","kubernetes.taskmanager.cpu.limit-factor":"10.0","rest.flamegraph.enabled":"true","state.backend":"hashmap","taskmanager.numberOfTaskSlots":"2"}` | Flink configuration For metrics configuration, see here:  <https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/metric_reporters/> |
| restartNonce | int | `0` | change this to force a restart of the job, see <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/> for more info |
| logConfiguration | object | `{}` | Custom logging configuration |
| mode | string | `"native"` | Cluster deployment mode. Support values are `native` and `standalone` `native` is the recommended mode, as this makes Flink aware of it running on Kubernetes |
| ports | list | `[]` | Extra ports to open on both job- and task-manager |
| env | list | `[]` | Extra environment variables to set on both job- and task-manager |
| envFrom | list | `[]` | List of ConfigMap/Secrets where environment variables can be loaded from |
| volumes | list | `[]` | List of additional volumes for the both job- and task-manager |
| volumeMounts | list | `[]` | List of additional volume mounts for the both job- and task-manager |
| podLabels | object | `{}` | Additional labels attached to the pods |
| podAnnotations | object | `{}` | Additional annotations attached to the pods |
| job.jarURI | string | `""` | The path of the job jar |
| job.entryClass | string | `""` | The name of the job class |
| job.args | list | `[]` | Arguments for the job |
| job.parallelism | int | `2` | How many jobs to run in parallel, see more here: <https://nightlies.apache.org/flink/flink-docs-master/docs/dev/datastream/execution/parallel/> |
| job.state | string | `"running"` | Desired state of the job. Must be either: `running` or `suspended` |
| job.upgradeMode | string | `"savepoint"` | Application upgrade mode. Must be either: stateless, last_state, savepoint `stateless` upgrades is done from an empty state `last-state` does a quick upgrade. Does not require the job to be in a healthy state `savepoint` makes use of savepoints when upgrading and requires the job to be running. This provides maximal safety Read more here: <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/#stateful-and-stateless-application-upgrades> |
| job.savepointTriggerNonce | int | `0` | change this to trigger a savepoint manually, see more here: <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/> |
| job.initialSavepointPath | string | `""` | change this to force a manual recovery checkpoint, see more here: <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/> |
| job.allowNonRestoredState | bool | `false` | If this is true, it will ignore the past checkpoints and start anew. Usefull if the job schema has changed. |
| podTemplate | string | (see values.yaml) | Shared job-/task-manager pod template. Overridden by `(job/task)Manager.podTemplate`. The main flink-container must be called "flink-main-container" |
| taskManager.replicas | int | `1` | Number of replicas |
| taskManager.resource.memory | string | `"1Gb"` | Memory to reserve for each Task Manager. The amount needed depends on the amount of data to be processed by each Task Manager, and how much state it should store in memory. |
| taskManager.resource.cpu | float | `0.1` | CPU requests. CPU limits is CPU requests multiplied by flinkConfiguration."kubernetes.jobmanager.cpu.limit-factor" |
| taskManager.ports | list | `[]` | Extra ports to open |
| taskManager.env | list | `[]` | Extra environment variables |
| taskManager.envFrom | list | `[]` | List of ConfigMap/Secrets where environment variables can be loaded from |
| taskManager.volumes | list | `[]` | List of additional volumes |
| taskManager.volumeMounts | list | `[]` | List of additional volume mounts |
| taskManager.podLabels | object | `{}` | Additional labels attached to the pods |
| taskManager.podAnnotations | object | `{}` | Additional annotations attached to the pods |
| taskManager.podTemplate | string | (see values.yaml) | Pod template. Overrides the main `podTemplate`. The main flink-container must be called "flink-main-container" |
| jobManager.replicas | int | `1` | Number of replicas |
| jobManager.resource.memory | string | `"1Gb"` | Memory to reserve for the Job Manager. The default value should be ok for most jobs. |
| jobManager.resource.cpu | float | `0.1` | CPU requests. CPU limits is CPU requests multiplied by flinkConfiguration."kubernetes.jobmanager.cpu.limit-factor" |
| jobManager.ports | list | `[]` | Extra ports to open |
| jobManager.env | list | `[]` | Extra environment variables |
| jobManager.envFrom | list | `[]` | List of ConfigMap/Secrets where environment variables can be loaded from |
| jobManager.volumes | list | `[]` | List of additional volumes |
| jobManager.volumeMounts | list | `[]` | List of additional volume mounts |
| jobManager.podLabels | object | `{}` | Additional labels attached to the pods |
| jobManager.podAnnotations | object | `{}` | Additional annotations attached to the pods |
| jobManager.podTemplate | string | (see values.yaml) | Pod template. Overrides the main `podTemplate`. The main flink-container must be called "flink-main-container" |
| metrics.enabled | bool | `true` | Enable metrics scraping. Define flinkProperties to define the monitoring properties |
| metrics.port | int | `9249` | Port on both job- and task-manager where metrics are exposed |
| metrics.podMonitor.enabled | bool | `true` |  |
| metrics.podMonitor.path | string | `""` | Override the metrics scrape path |
| metrics.podMonitor.interval | string | `""` | Override the default scrape interval |
| metrics.podMonitor.scrapeTimeout | string | `""` | Override the default scrape timeout |
| metrics.podMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion |
| metrics.podMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| metrics.podMonitor.selectors | object | `{}` | Extra pod selector labels |
| metrics.podMonitor.labels | object | `{}` | Extra PodMonitor labels |
| metrics.podMonitor.extraMetricsEndpoints | list | `[]` | Extra podmonitor metrics endpoints |
| metrics.podMonitor.targetLabels | list | `["component","cluster"]` | Copy pod labels onto the metrics targets |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceAccount.automountServiceAccountToken | bool | `true` | Auto-mount service account tokens |
| rbac.create | bool | `true` | Specifies whether a Role and RoleBinding should be created |
| rbac.additionalRules | list | `[]` | Additional rules to add to the role |
| podSecurityContext.runAsNonRoot | bool | `true` | Whether to run the pod without root capabilities |
| podSecurityContext.fsGroup | int | `9999` | Add a supplimentary group ID to all processes in the container. Set the owner of all volumes to this group |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Which secure computing mode (seccomp) profile to use |
| securityContext.allowPrivilegeEscalation | bool | `false` | Allow privilege escalation |
| securityContext.runAsGroup | int | `9999` | User to run the container as |
| securityContext.runAsUser | int | `9999` | Group to add the user to |
| securityContext.capabilities.drop | list | `["ALL"]` | Linux capabilities to drop |
| securityContext.capabilities.add | list | `[]` | Linux capabilities to add |
| ingress.enabled | bool | `false` | Whether to expose the Flink UI, on the job-manager |
| ingress.uiPort | int | `8081` | Flink UI port. Ingress will hit the service on this port |
| ingress.ingressClassName | string | `""` | Ingress controller name |
| ingress.hostname | string | `"flink.cheetah.trifork.dev"` | Which host name to use for the Flink UI |
| ingress.path | string | `"/"` | Which subpath to expose the Flink UI under |
| ingress.pathType | string | `"ImplementationSpecific"` | Which path type to use |
| ingress.annotations | object | `{}` | Extra Ingress annotations |
| ingress.tlsSecret | string | `""` | Add TLS certificates from an existing secret |
| ingress.selfSigned | bool | `false` | Create a self-signed TLS secret |
| image-automation | object | `{"enabled":false}` | Settings passed to the image-automation chart, Image-automation is not possible when using image-sha as a tagging strategy |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
