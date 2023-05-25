# cheetah-application

![Version: 0.6.2](https://img.shields.io/badge/Version-0.6.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| replicaCount | int | `1` |  |
| image.repository | string | `""` | Image repository. Such as ghcr.io/trifork/cheetah-webapi |
| image.tag | string | `""` | Image tag |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| global | object | `{"image":{"repository":""},"imagePullSecrets":[]}` | Only used to decrease duplicate configuration of this chart, if imageAutomation is used as a sub chart. Overrides the local values if given |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| command | list | `[]` | Override the default command |
| args | list | `[]` | Override the arguments to the command |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerPort | int | `8000` |  |
| volumes | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `8000` |  |
| ingress.enabled | bool | `false` | Whether to expose the service or not |
| ingress.className | string | `"nginx"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect" | string | `"true"` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| ingress.hosts[0] | object | `{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}` | Which host to expose the service under |
| ingress.tls.enabled | bool | `true` |  |
| ingress.tls.secretName | string | `""` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.httpGet.path | string | `"/"` |  |
| startupProbe.httpGet.port | string | `"http"` |  |
| startupProbe.initialDelaySeconds | int | `30` |  |
| startupProbe.failureThreshold | int | `3` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.timeoutSeconds | int | `1` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.httpGet.path | string | `"/"` | Which path to look for liveness |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.httpGet.path | string | `"/"` | Which path to look for readiness |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| resources | object | `{}` | Resource limits. See `values.yaml` for an example |
| monitoring | object | `{"enabled":false,"path":"/metrics","port":1854}` | Observability settings |
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
| image-automation | object | `{"enabled":false}` | Settings passed to the image-automation chart |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
