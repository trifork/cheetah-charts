// This file contains the specification for the Cheetah Redpanda Console Helm Chart.
// It provides information about the default values and descriptions of settings in the chart.// The "chart.valuesTable" template generates a table of settings and their descriptions.
// It also includes the default values for each setting.

# Cheetah Redpanda Console Helm Chart Specification

### Description: 
Find the default values and descriptions of settings in the Cheetah Redpanda Console Helm chart. 

![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.8.5](https://img.shields.io/badge/AppVersion-v2.8.5-informational?style=flat-square)


Disclaimer - This chart is an extension of the official Cheetah Redpanda Console Helm Chart.
The original source code can be found at https://github.com/redpanda-data/helm-charts/tree/main/charts/console.
The extension is used by Cheetah to meet their requirements for the chart.

In particular, this page describes the contents of the chart’s [`values.yaml` file](https://github.com/redpanda-data/helm-charts/blob/main/charts/console/values.yaml).
Each of the settings is listed and described on this page, along with any default values.

For instructions on how to install and use the chart, refer to the [deployment documentation](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/kubernetes/kubernetes-deploy/).
For instructions on how to override and customize the chart’s values, see [Configure Cheetah Redpanda Console](https://docs.redpanda.com/docs/manage/kubernetes/configure-helm-chart/#configure-redpanda-console).

## Settings specific for Cheetah Redpanda Console
This chart uses the following settings that are specific to Cheetah Redpanda Console and must be set through values:

- values for oauth2Proxy
  - image: [Your chosen image of oauth2Proxy]
  - issuerUrl: [Your issuer URL]
  - OAUTH2_PROXY_COOKIE_SECRET: [Your cookie secret]
  - OAUTH2_PROXY_CLIENT_ID: [Your client ID]
  - OAUTH2_PROXY_CLIENT_SECRET: [Your client secret]

- extraEnv
  - extraEnv variables to set up kafka
    - KAFKA_SASL_OAUTH_CLIENTID: [Your client ID]
    - KAFKA_SASL_OAUTH_CLIENTSECRET: [Your client secret]
    - KAFKA_SASL_OAUTH_SCOPE: [Your scope]

- kafka:
  - brokers: [Your brokers]
  - sasl:
    - oauth:
      - tokenEndpoint: [Your token endpoint]
  - schemaRegistry:
    - urls: [Your URLs]
  - tls: [Your TLS settings]

See an example of how the values can be set through a release at the bottom of this readme




## Settings

| Key | Description | Default |
|-----|-------------|---------|
| [replicaCount](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=replicaCount) |  | `1` |
| [image.registry](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=image.registry) |  | `"docker.redpanda.com"` |
| [image.repository](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=image.repository) |  | `"redpandadata/console"` |
| [image.pullPolicy](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=image.pullPolicy) |  | `"IfNotPresent"` |
| [image.tag](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=image.tag) |  | `"v2.8.5"` |
| [podLabels](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=podLabels) |  | `nil` |
| [service.type](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=service.type) |  | `"ClusterIP"` |
| [service.port](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=service.port) |  | `4180` |
| [service.targetPort](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=service.targetPort) |  | `4180` |
| [service.appProtocol](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=service.appProtocol) |  | `"http"` |
| [service.annotations](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=service.annotations) | Override the value in `console.config.server.listenPort` if not `nil` | `{}` |
| [ingress.enabled](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.enabled) |  | `false` |
| [ingress.className](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.className) |  | `"nginx"` |
| [ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect"](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect") |  | `"true"` |
| [ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect"](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect") |  | `"true"` |
| [ingress.annotations."cert-manager.io/cluster-issuer"](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.annotations."cert-manager.io/cluster-issuer") |  | `"letsencrypt-prod"` |
| [ingress.hosts[0].host](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.hosts[0].host) |  | `"chart-example.local"` |
| [ingress.hosts[0].paths[0].path](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.hosts[0].paths[0].path) |  | `"/"` |
| [ingress.hosts[0].paths[0].pathType](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.hosts[0].paths[0].pathType) |  | `"ImplementationSpecific"` |
| [ingress.tls](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=ingress.tls) |  | `[]` |
| [podSecurityContext.seccompProfile.type](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=podSecurityContext.seccompProfile.type) |  | `"RuntimeDefault"` |
| [podSecurityContext.runAsUser](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=podSecurityContext.runAsUser) |  | `99` |
| [podSecurityContext.fsGroup](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=podSecurityContext.fsGroup) |  | `99` |
| [securityContext.runAsNonRoot](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=securityContext.runAsNonRoot) |  | `true` |
| [securityContext.capabilities.drop[0]](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=securityContext.capabilities.drop[0]) |  | `"ALL"` |
| [securityContext.allowPrivilegeEscalation](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=securityContext.allowPrivilegeEscalation) |  | `false` |
| [securityContext.readOnlyRootFilesystem](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=securityContext.readOnlyRootFilesystem) |  | `true` |
| [console.config.kafka.brokers](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.brokers) |  | `[]` |
| [console.config.kafka.sasl.enabled](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.sasl.enabled) |  | `true` |
| [console.config.kafka.sasl.mechanism](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.sasl.mechanism) |  | `"OAUTHBEARER"` |
| [console.config.kafka.sasl.oauth.tokenEndpoint](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.sasl.oauth.tokenEndpoint) |  | `nil` |
| [console.config.kafka.schemaRegistry.enabled](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.schemaRegistry.enabled) |  | `true` |
| [console.config.kafka.schemaRegistry.urls](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.kafka.schemaRegistry.urls) |  | `[]` |
| [console.config.analytics.enabled](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.config.analytics.enabled) |  | `false` |
| [console.roles](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.roles) |  | `{}` |
| [console.roleBindings](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=console.roleBindings) |  | `{}` |
| [oauth2Proxy.image.registry](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.image.registry) |  | `"quay.io"` |
| [oauth2Proxy.image.repository](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.image.repository) |  | `"oauth2-proxy/oauth2-proxy"` |
| [oauth2Proxy.image.pullPolicy](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.image.pullPolicy) |  | `"Always"` |
| [oauth2Proxy.image.tag](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.image.tag) |  | `"v7.12.0"` |
| [oauth2Proxy.issuerUrl](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.issuerUrl) |  | `""` |
| [oauth2Proxy.cookieName](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.cookieName) |  | `"__Host-_oauth2Proxy"` |
| [oauth2Proxy.emailDomain](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.emailDomain) |  | `"*"` |
| [oauth2Proxy.env[0].name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[0].name) |  | `"OAUTH2_PROXY_COOKIE_SECRET"` |
| [oauth2Proxy.env[0].valueFrom.secretKeyRef.name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[0].valueFrom.secretKeyRef.name) |  | `"redpanda-oauth2-proxy"` |
| [oauth2Proxy.env[0].valueFrom.secretKeyRef.key](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[0].valueFrom.secretKeyRef.key) |  | `"cookie-secret"` |
| [oauth2Proxy.env[1].name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[1].name) |  | `"OAUTH2_PROXY_CLIENT_ID"` |
| [oauth2Proxy.env[1].valueFrom.secretKeyRef.name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[1].valueFrom.secretKeyRef.name) |  | `"redpanda-oauth2-proxy"` |
| [oauth2Proxy.env[1].valueFrom.secretKeyRef.key](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[1].valueFrom.secretKeyRef.key) |  | `"client-id"` |
| [oauth2Proxy.env[2].name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[2].name) |  | `"OAUTH2_PROXY_CLIENT_SECRET"` |
| [oauth2Proxy.env[2].valueFrom.secretKeyRef.name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[2].valueFrom.secretKeyRef.name) |  | `"redpanda-oauth2-proxy"` |
| [oauth2Proxy.env[2].valueFrom.secretKeyRef.key](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=oauth2Proxy.env[2].valueFrom.secretKeyRef.key) |  | `"OAUTH2_PROXY_CLIENT_SECRET"` |
| [imagePullSecrets](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=imagePullSecrets) | Pull secrets may be used to provide credentials to image repositories See https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ | `[]` |
| [nameOverride](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=nameOverride) | Override `console.name` template. | `""` |
| [fullnameOverride](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=fullnameOverride) | Override `console.fullname` template. | `""` |
| [automountServiceAccountToken](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=automountServiceAccountToken) | Automount API credentials for the Service Account into the pod. | `true` |
| [serviceAccount.create](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=serviceAccount.create) | Specifies whether a service account should be created. | `true` |
| [serviceAccount.automountServiceAccountToken](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=serviceAccount.automountServiceAccountToken) | Specifies whether a service account should automount API-Credentials | `true` |
| [serviceAccount.annotations](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=serviceAccount.annotations) | Annotations to add to the service account. | `{}` |
| [serviceAccount.name](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=serviceAccount.name) | The name of the service account to use. If not set and `serviceAccount.create` is `true`, a name is generated using the `console.fullname` template | `""` |
| [commonLabels](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=commonLabels) |  | `{}` |
| [annotations](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=annotations) | Annotations to add to the deployment. | `{}` |
| [podAnnotations](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=podAnnotations) |  | `{}` |
| [resources.limits.memory](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=resources.limits.memory) |  | `"64Mi"` |
| [resources.requests.cpu](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=resources.requests.cpu) |  | `"5m"` |
| [resources.requests.memory](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=resources.requests.memory) |  | `"16Mi"` |
| [autoscaling.enabled](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=autoscaling.enabled) |  | `false` |
| [autoscaling.minReplicas](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=autoscaling.minReplicas) |  | `1` |
| [autoscaling.maxReplicas](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=autoscaling.maxReplicas) |  | `100` |
| [autoscaling.targetCPUUtilizationPercentage](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=autoscaling.targetCPUUtilizationPercentage) |  | `80` |
| [nodeSelector](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=nodeSelector) |  | `{}` |
| [extraContainers](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=extraContainers) |  | `[]` |
| [tolerations](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=tolerations) |  | `[]` |
| [affinity](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=affinity) |  | `{}` |
| [topologySpreadConstraints](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=topologySpreadConstraints) |  | `{}` |
| [priorityClassName](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=priorityClassName) | PriorityClassName given to Pods. For details, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass). | `""` |
| [extraEnv](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=extraEnv) | Additional environment variables for the Redpanda Console Deployment. | `[]` |
| [extraEnvFrom](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=extraEnvFrom) | Additional environment variables for Redpanda Console mapped from Secret or ConfigMap. | `[]` |
| [extraVolumes](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=extraVolumes) | Add additional volumes, such as for TLS keys. | `[]` |
| [extraVolumeMounts](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=extraVolumeMounts) |  | `[]` |
| [initContainers](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=initContainers) | Any initContainers defined should be written here | `{"extraInitContainers":""}` |
| [initContainers.extraInitContainers](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=initContainers.extraInitContainers) | Additional set of init containers | `""` |
| [secretMounts](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=secretMounts) | SecretMounts is an abstraction to make a Secret available in the container's filesystem. Under the hood it creates a volume and a volume mount for the Redpanda Console container. | `[]` |
| [secret](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=secret) | Create a new Kubernetes Secret for all sensitive configuration inputs. Each provided Secret is mounted automatically and made available to the Pod. If you want to use one or more existing Secrets, you can use the `extraEnvFrom` list to mount environment variables from string and secretMounts to mount files such as Certificates from Secrets. | <pre>{"create":true,"enterprise":{},"kafka":{},"login":{"github":{},"google":{},"jwtSecret":"","oidc":{},"okta":{}},"redpanda":{"adminApi":{}}}</pre> |
| [secret.kafka](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=secret.kafka) | Kafka Secrets. | `{}` |
| [enterprise](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=enterprise) | Settings for license key, as an alternative to secret.enterprise when a license secret is available | <pre>{"licenseSecretRef":{"key":"","name":""}}</pre> |
| [livenessProbe](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=livenessProbe) | Settings for liveness and readiness probes. For details, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes). | <pre>{"failureThreshold":3,"httpGet":{"path":"/ping","port":"http-proxy"},"initialDelaySeconds":5,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":1}</pre> |
| [readinessProbe.initialDelaySeconds](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.initialDelaySeconds) | Grant time to test connectivity to upstream services such as Kafka and Schema Registry. | `5` |
| [readinessProbe.periodSeconds](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.periodSeconds) |  | `5` |
| [readinessProbe.timeoutSeconds](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.timeoutSeconds) |  | `1` |
| [readinessProbe.successThreshold](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.successThreshold) |  | `1` |
| [readinessProbe.failureThreshold](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.failureThreshold) |  | `3` |
| [readinessProbe.httpGet.path](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.httpGet.path) |  | `"/ping"` |
| [readinessProbe.httpGet.port](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=readinessProbe.httpGet.port) |  | `"http-proxy"` |
| [configmap.create](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=configmap.create) |  | `true` |
| [deployment.create](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=deployment.create) |  | `true` |
| [deployment.command](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=deployment.command) |  | `[]` |
| [deployment.extraArgs](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=deployment.extraArgs) |  | `[]` |
| [strategy](https://artifacthub.io/packages/helm/redpanda-data/console?modal=values&path=strategy) |  | `{}` |




----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)


# An example of how to set these values and use the helm chart through a release is shown below:
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: redpanda-console-oauth2proxy-example
  namespace: redpanda-console-oauth2proxy-example
spec:
  chart:
    spec:
      chart: redpanda-console-oauth2proxy
      version: 1.2.0
      sourceRef:
        name: cheetah-charts
        kind: HelmRepository
        namespace: default
  interval: 30m
  timeout: 10m0s
  values:
    image:
      repository: redpandadata/console
      registry: docker.io
      tag: v2.5.2

    service:
      targetPort: example # This is the port that the service will route to

    console:
      config:
        kafka:
          brokers:
            - <broker-url>
          sasl:
            oauth:
              tokenEndpoint: <token-endpoint> # Could be Keycloak URL
          schemaRegistry:
            urls:
              - <schema-registry-url>
          tls:
            enabled: true
            caFilepath: /tmp/kafka/ca.crt
            insecureSkipTlsVerify: false

    oauth2Proxy:
      issuerUrl: https://keycloak.cheetah.example/realms/<realm> # Keycloak URL
      env:
      - name: OAUTH2_PROXY_COOKIE_SECRET
        valueFrom:
          secretKeyRef:
            name: redpanda-oauth2-proxy
            key: cookie-secret
      - name: OAUTH2_PROXY_CLIENT_ID
        valueFrom:
          secretKeyRef:
            name: redpanda-oauth2-proxy
            key: client-id
      - name: OAUTH2_PROXY_CLIENT_SECRET
        valueFrom:
          secretKeyRef:
            name: redpanda-oauth2-proxy
            key: OAUTH2_PROXY_CLIENT_SECRET

    extraEnv:
      - name: KAFKA_SASL_OAUTH_CLIENTID
        valueFrom:
          secretKeyRef:
            name: redpanda-credentials
            key: client-id
      - name: KAFKA_SASL_OAUTH_CLIENTSECRET
        valueFrom:
          secretKeyRef:
            name: redpanda-credentials
            key: client-secret
      - name: KAFKA_SASL_OAUTH_SCOPE
        value: kafka
    secretMounts:
      - name: kafka-ca
        secretName: kafka-ca
        path: /tmp/kafka/

    ingress:
      enabled: true
      hosts:
        - host: example.redpanda.cheetah.trifork.dev
          paths:
            - path: /
              pathType: ImplementationSpecific
      tls:
        - hosts:
            - example.redpanda.cheetah.trifork.dev
          secretName: redpanda-cheetah-cert
```