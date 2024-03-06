# cheetah-application

![Version: 0.7.1](https://img.shields.io/badge/Version-0.7.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for Cheetah Data Platform applications

## Usage

As pods are not allowed to run as root by default with this chart, installing/upgrading this chart might give an error similar to:

```log
Error: container has runAsNonRoot and image will run as root ...
```

This happens when a user has not been defined in your `Dockerfile`.

To get around the issue, you can set the user to a non-zero (integer) in your `Dockerfile`.
Alternatively, if you know that the container should be able to run with user `1000`, set `securityContext.runAsUser=1000`.
You might also need to set `securityContext.runAsGroup` and `securityContext.fsGroup`.
If the container must run as root, you can set `podSecurityContext.runAsNonRoot=false` (if [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) are not enforced)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../image-automation | image-automation | * |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of pod replicas. For high availability, 3 or more is recommended |
| image.repository | string | `""` | Which image repository to use. Such as ghcr.io/trifork/cheetah-webapi |
| image.tag | string | `""` | Which image tag to use |
| image.pullPolicy | string | `"IfNotPresent"` | Which image pull policy to use |
| global.image.repository | string | `""` | Set the global image repository If image automation is enabled, this is useful to reduce configuration duplication |
| global.imagePullSecrets | list | `[]` | Set the global image pull secrets If image automation is enabled, this is useful to reduce configuration duplication |
| imagePullSecrets | list | `[]` | Array of image pull secrets. Each entry follows the `name: <secret-name>` format |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| command | list | `[]` | Override the default command |
| args | list | `[]` | Override the arguments to the command |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podLabels | object | `{}` | Extra pod labels |
| podAnnotations | object | `{}` | Extra pod annotations |
| containerPort | int | `8000` | Which container port to use for primary traffic |
| volumes | list | `[]` | Extra volumes added to the pod See https://kubernetes.io/docs/concepts/storage/volumes/ |
| volumeMounts | list | `[]` | Extra volume mounts added to the primary container See https://kubernetes.io/docs/concepts/storage/volumes/ |
| service.type | string | `"ClusterIP"` | Which type of service to expose the pods with |
| service.port | int | `8000` | Which service port to use |
| ingress.enabled | bool | `false` | Whether to expose the service or not |
| ingress.className | string | `"nginx"` | Which ingressClass to use |
| ingress.annotations | object | (see [values.yaml](values.yaml)) | Extra ingress annotations. |
| ingress.hosts | list | `[]` | Host configuration. See [values.yaml](values.yaml) for formatting |
| ingress.tls.enabled | bool | `true` | Enable TLS in the ingress resource |
| ingress.tls.secretName | string | `""` | Secret containing TLS certificates |
| env | list | `[]` | Extra environment variables for the container. See [values.yaml](values.yaml) for formatting |
| envFrom | list | `[]` | Extra sources of environment variables, such as ConfigMap/Secret. See [values.yaml](values.yaml) for formatting |
| startupProbe.enabled | bool | `false` | Whether to enable a startup probe for the application. This generally not recommended, but can be used for slow-starting applications. See https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| startupProbe.httpGet.path | string | `"/"` | Which path to look for liveness |
| startupProbe.httpGet.port | string | `"http"` | Which port to use |
| startupProbe.initialDelaySeconds | int | `30` |  |
| startupProbe.failureThreshold | int | `3` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.timeoutSeconds | int | `1` |  |
| livenessProbe.enabled | bool | `true` | Whether to enable a liveness probe for the application. See https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| livenessProbe.httpGet.path | string | `"/"` | Which path to look for liveness |
| livenessProbe.httpGet.port | string | `"http"` | Which port to use |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.enabled | bool | `true` | Whether to enable a readiness probe for the application. See https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| readinessProbe.httpGet.path | string | `"/"` | Which path to look for readiness |
| readinessProbe.httpGet.port | string | `"http"` | Which port to use |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| resources | object | `{}` | Resource limits. See [values.yaml](values.yaml) for formatting |
| podSecurityContext | object | (see [values.yaml](values.yaml)) | Security context for the entire pod. |
| securityContext | object | (see [values.yaml](values.yaml)) | Security context for the primary container. |
| monitoring.enabled | bool | `false` | Whether to enable Prometheus scraping by creating a ServiceMonitor resource |
| monitoring.port | int | `1854` | Which port to look for Prometheus metrics |
| monitoring.path | string | `"/metrics"` | Which path to look for Prometheus metrics |
| pdb.create | bool | `false` | Whether to create a PodDisruptionBudget for ensuring that an application is always available |
| pdb.labels | object | `{}` | Extra labels for the PodDisruptionBudget |
| pdb.annotations | object | `{}` | Extra annotations for the PodDisruptionBudget |
| pdb.minAvailable | int | `1` | How many pod replicas must always be available after eviction. Ignored if 0 |
| pdb.maxUnavailable | int | `0` | How many pod replicas are allowed to to be unavailable during eviction. Ignored if 0 |
| autoscaling.enabled | bool | `false` | Whether to enable horizontal pod autoscaling |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| autoscaling.maxReplicas | int | `5` | Maximum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU requests percentage utilization. Ignored if 0 |
| autoscaling.targetMemoryUtilizationPercentage | int | `0` | Target RAM requests percentage utilization. Ignored if 0 |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| image-automation.enabled | bool | `false` | Whether to enable the image-automation subchart. Any other configuration given here, is passed to it |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
