# flink-job

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for handling Cheetah Data Platform Flink jobs

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../image-automation | image-automation | * |

## Usage

### Changing CPU limits

By default, the Flink operator sets CPU/Memory resource limits equal to the requests.
Sometimes, it could preferable to increase the CPU/memory limits, which could be done on both the job- and task-manager, using:

```yaml
flinkConfiguration:
  kubernetes.jobmanager.cpu.limit-factor: "5.0"
  kubernetes.taskmanager.cpu.limit-factor: "5.0"
  kubernetes.jobmanager.memory.limit-factor: "2.0"
  kubernetes.taskmanager.memory.limit-factor: "2.0"
```

This makes the CPU limit 5 times the CPU requests for both managers, and the memory limit 2 times the memory requests.

### Keeping state

For setting up savepoint/checkpoint/HA metadata state, it is possible to make use of a helper function.
This is done by setting `storage.scheme` and `storage.baseDir`.
These configure the file system scheme (such as local file system, Amazon S3, Azure Blob Storage), and the base directory in the file system (such as `/flink/data`), respectively.
See [below](#values) for documentation on how to use these.

It is possible to use local storage such as a Persistent Volume or using a path directly on the host node (not recommended).
This can be a nice to use for development and quick testing, but is not recommended for production as many Kubernetes distributions doesn't support `ReadWriteMany` access modes.
To set up using a Persistent Volume for storage, create a Persistent Volume Claim similar to this:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: flink-volume
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard
```

Mounting the Persistent Volume created by the `standard` StorageClass, is done by setting the following in the values file:

```yaml
volumeMounts:
  - mountPath: /flink-data
    name: flink-volume
volumes:
  - name: flink-volume
    persistentVolumeClaim:
      claimName: flink-volume
```

To tell the Flink job to use the `/flink-data` directory for file storage, set:

```yaml
storage:
  scheme: file
  baseDir: /flink-data
```

This tells Flink where to keep savepoint, checkpoint, and HA metadata data (if applicable).

Depending on which file system to use for keeping state, custom configuration might be required.
For example, to set up storage to an S3 bucket at the `/flink/data` directory, set `storage.scheme=s3` and `storage.baseDir=/flink/data`.
Authentication is done using the `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` environment variables (the `AWS_` prefix is required for all S3-like storage systems, even if AWS has nothing to do with it).
If these are kept in a secret looking like this

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: s3-credentials
data:
  AWS_ACCESS_KEY: YWNjZXNzLWtleQ==
  AWS_SECRET_KEY: c2VjcmV0LWtleQ==
```

the environment variables can be loaded by setting

```yaml
envFrom:
  - secretRef:
      name: s3-credentials
```

This adds the environment variables from the `s3-credentials` Secret to both the job- and task-manager(s).
It is also necessary to set the `flinkConfiguration."s3.endpoint"` to the endpoint of your S3 system.

Sometimes it is also necessary to set `flinkConfiguration."s3.path-style-access"="true"`, in order to work around some S3 object stores not having virtual host style addressing enabled (such as with MinIO).
See <https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/filesystems/s3/> for more documentation on S3 and Flink.

### Job-manager HA mode

By default, there is a single JobManager instance per Flink cluster.
This creates a single point of failure (SPOF): if the JobManager crashes, no new programs can be submitted and running programs fail.

This is normally not a problem with the Flink operator, as the job-manager is owned by a single-replica Kubernetes Deployment/ReplicaSet, which will start a new job-manager pod up if it crashes.
However, for guarenteed availability, it is possible to run the job-manager in multi-replica mode, using a leader election system.

Whenever `jobManager.replicas > 1` is set, a helper function will set the needed configuration in `flinkConfiguration`.

Read more about Flink and highly available job-managers [here](https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/ha/overview/).

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
| version | string | `"v1_16"` | Which Flink version to use |
| flinkConfiguration | object | (see values.yaml) | Flink configuration For more configuration options, see here: <https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/config/> For specific metrics configuration, see here:  <https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/metric_reporters/> |
| restartNonce | int | `0` | change this to force a restart of the job, see <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/> for more info |
| logConfiguration | object | `{}` | Custom logging configuration |
| mode | string | `"native"` | Cluster deployment mode. Support values are `native` and `standalone` `native` is the recommended mode, as this makes Flink aware of it running on Kubernetes |
| storage.scheme | string | `""` | File storage scheme. Allowed values follows supported URI schemes, as explained [here](https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/filesystems/overview/) To use S3 storage set `scheme=s3`, to use local file-system use `scheme=file`, etc. |
| storage.baseDir | string | `""` | Set the base directory for the HA, savepoints, and checkpoints storage. Generates a directory tree, based on the file system scheme, base directory, release name, and storage type (savepoint, checkpoint, or HA metadata) |
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
| job.topics | list | `[]` | Define which topics this job will consume. Used for data-discovery in Cheetah Backstage. If the `arg` variable is set, adds `--<arg> <name>` to the arguments passed to the job See `values.yaml` for the format |
| job.parallelism | int | `2` | How many jobs to run in parallel, see more here: <https://nightlies.apache.org/flink/flink-docs-master/docs/dev/datastream/execution/parallel/> |
| job.state | string | `"running"` | Desired state of the job. Must be either: `running` or `suspended` |
| job.upgradeMode | string | `"savepoint"` | Application upgrade mode. Must be either: stateless, last_state, savepoint `stateless` upgrades is done from an empty state `last-state` does a quick upgrade. Does not require the job to be in a healthy state, as it makes use of the HA metadata `savepoint` makes use of savepoints when upgrading and requires the job to be running. This provides maximal safety Read more here: <https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/custom-resource/job-management/#stateful-and-stateless-application-upgrades> |
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
| metrics.service.enabled | bool | `true` | Whether to enable the service for metrics |
| metrics.service.protocol | string | `TCP` | Override the protocol for transporting metrics |
| metrics.service.targetPort | string | `metrics` | Override the target port for metrics |
| metrics.service.type | string | `ClusterIP` | Override the service type |
| metrics.service.selectors | object | `{}` | Extra pod selector labels |
| metrics.service.labels | object |`{}` | Extra Service labels |
| metrics.serviceMonitor.enabled | bool | `true` |  |
| metrics.serviceMonitor.path | string | `""` | Override the metrics scrape path |
| metrics.serviceMonitor.interval | string | `""` | Override the default scrape interval |
| metrics.serviceMonitor.scrapeTimeout | string | `""` | Override the default scrape timeout |
| metrics.serviceMonitor.metricRelabelings | list | `[]` | MetricRelabelConfigs to apply to samples before ingestion |
| metrics.serviceMonitor.relabelings | list | `[]` | RelabelConfigs to apply to samples before scraping |
| metrics.serviceMonitor.selectors | object | `{}` | Extra pod selector labels |
| metrics.serviceMonitor.labels | object | `{}` | Extra serviceMonitor labels |
| metrics.serviceMonitor.extraMetricsEndpoints | list | `[]` | Extra serviceMonitor metrics endpoints |
| metrics.serviceMonitor.targetLabels | list | `["component","cluster"]` | Copy pod labels onto the metrics targets |
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
