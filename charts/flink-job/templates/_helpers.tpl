{{/*
Expand the name of the chart.
*/}}
{{- define "flink-job.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flink-job.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "flink-job.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Builds the image identifier with either sha or tag
*/}}
{{- define "flink-job.image" -}}
{{- $repository := coalesce .Values.global.image.repository .Values.image.repository }}
{{- if .Values.image.sha }}
{{- printf "%s@sha256:%s" $repository .Values.image.sha }}
{{- else }}
{{- printf "%s:%s" $repository (.Values.image.tag | toString) }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "flink-job.labels" -}}
helm.sh/chart: {{ include "flink-job.chart" . }}
{{ include "flink-job.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "flink-job.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flink-job.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Pod labels
*/}}
{{- define "flink-job.podLabels" -}}
{{ include "flink-job.labels" . }}
app.kubernetes.io/component: metrics
backstage.io/kubernetes-id: {{ .Release.Name }}
{{ with .Values.metrics.serviceMonitor.selectors -}}
  {{- toYaml . }}
{{- end }}
{{ with .Values.podLabels -}}
  {{- toYaml . }}
{{- end }}
{{- end -}}

{{/*
Pod annotations
*/}}
{{- define "flink-job.podAnnotations" -}}
{{- with .Values.podAnnotations }}
  {{- toYaml . }}
{{- end }}
{{ include "flink-job.backstageTopicAnnotations" . }}
{{- end -}}

{{/*
Taskmanager Pod annotations
*/}}
{{- define "flink-job.taskManagerPodAnnotations" -}}
{{- with .Values.taskManager.podAnnotations }}
  {{- toYaml . }}
{{- end }}
{{- if .Values.istio.enabled }}
{{- if not (hasKey .Values.taskManager.podAnnotations "traffic.sidecar.istio.io/excludeOutboundPorts")}}
traffic.sidecar.istio.io/excludeOutboundPorts: "6123,6124,41475"
{{- end -}}
{{- if not (hasKey .Values.taskManager.podAnnotations "traffic.sidecar.istio.io/excludeInboundPorts")}}
traffic.sidecar.istio.io/excludeInboundPorts: "6122,6124,34101,41475"
{{- end -}}
{{- end }}
{{- end -}}

{{/*
Jobmanager Pod annotations
*/}}
{{- define "flink-job.jobManagerPodAnnotations" -}}
{{- with .Values.jobManager.podAnnotations }}
  {{- toYaml . }}
{{- end }}
{{- if .Values.istio.enabled }}
{{- if not (hasKey .Values.jobManager.podAnnotations "traffic.sidecar.istio.io/excludeOutboundPorts")}}
traffic.sidecar.istio.io/excludeOutboundPorts: "6122,6123,6124,34101,41475"
{{- end -}}
{{- if not (hasKey .Values.jobManager.podAnnotations "traffic.sidecar.istio.io/excludeInboundPorts")}}
traffic.sidecar.istio.io/excludeInboundPorts: "6123,6124,34101,41475"
{{- end -}}
{{- end }}
{{- end -}}

{{/*
Create the name of the FlinkDeployment resource
Needed to make sure that resource names does not surpass the character requirements
*/}}
{{- define "flink-job.flinkDeploymentName" -}}
{{ include "flink-job.fullname" . | trunc 45 }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "flink-job.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flink-job.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end -}}

{{- define "flink-job.backstageTopicAnnotations" -}}
{{- $inputs := "" -}}
{{- $outputs := "" -}}
{{- range .Values.job.topics -}}
  {{- if eq .type "input" -}}
    {{- $inputs = printf "%s,%s" $inputs .name -}}
  {{- else if eq .type "output" -}}
    {{- $outputs = printf "%s,%s" $outputs .name -}}
  {{- end -}}
{{- end -}}
{{- with $inputs -}}
backstage.io/input-kafka-topics: {{ . | trimPrefix "," }}
{{- end }}
{{- with $outputs }}
backstage.io/output-kafka-topics: {{ . | trimPrefix "," }}
{{- end }}
{{- end -}}

{{/*
Calculate the flinkConfiguration
*/}}
{{- define "flink-job.calculateConfigurations" -}}
  {{- $configs := .Values.flinkConfiguration -}}
  {{- $fullname := include "flink-job.fullname" . -}}
  {{- $configs = fromJson (include "flink-job.metricsConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.haConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.storageConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.istioConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.sslConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.java17CompatibilityConfiguration" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{- $configs = fromJson (include "flink-job.restartStrategy" (dict "configs" $configs "global" $.Values "fullname" $fullname)) -}}
  {{ toYaml $configs }}
{{- end -}}

{{/*
Add necessary metrics configuration
*/}}
{{- define "flink-job.metricsConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if .global.metrics.enabled -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.reporters" "prom")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.reporter.prom.port" (toString .global.metrics.port))) -}}
    {{- if eq "v1_15" .global.version -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.reporter.prom.class" "org.apache.flink.metrics.prometheus.PrometheusReporter")) -}}
    {{- else if has .global.version (list "v1_16" "v1_17" "v1_18") -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.reporter.prom.factory.class" "org.apache.flink.metrics.prometheus.PrometheusReporterFactory")) -}}
    {{- end -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Add necessary ssl configuration
*/}}
{{- define "flink-job.sslConfiguration" -}}
  {{- $configs := .configs -}}
  {{- $password := sha1sum (nospace (toString .global.image)) | trunc 10 }}
  {{- if .global.internalSsl.customCiphers.enabled -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.customCiphers.protocol" (toString .global.internalSsl.customCiphers.protocol))) -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.customCiphers.algorithms" (toString .global.internalSsl.customCiphers.algorithms))) -}}
  {{- end -}}
  {{- if .global.internalSsl.enabled -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.enabled" "true")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.keystore" "/flinkkeystore/keystore.jks")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.truststore" "/flinkkeystore/truststore.jks")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.keystore-password" (toString $password))) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.truststore-password" (toString $password))) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "security.ssl.internal.key-password" (toString $password))) -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}


{{/*
Add necessary istio configuration
*/}}
{{- define "flink-job.istioConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if .global.istio.enabled -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.internal.query-service.port" "34101")) -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "taskmanager.data.port" "41475")) -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Add necessary restart-strategy
*/}}
{{- define "flink-job.restartStrategy" -}}
  {{- $configs := .configs -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "restart-strategy" "failure-rate")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "jobmanager.execution.failover-strategy" "full")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "failover-strategy" "full")) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "restart-strategy.failure-rate.max-failures-per-interval" (toString "5"))) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "restart-strategy.failure-rate.failure-rate-interval" (toString "5 min"))) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "restart-strategy.failure-rate.delay" (toString "10 s"))) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "restart-strategy.failure-rate.max-failures-per-interval" (toString "5"))) -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Add necessary configuration for running in HA mode
*/}}
{{- define "flink-job.haConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if or (gt (int .global.jobManager.replicas) 1) (or (eq .global.job.upgradeMode "last-state") (and .global.storage.scheme .global.storage.baseDir)) -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "high-availability" "kubernetes")) -}}
    {{- if and .global.storage.scheme .global.storage.baseDir -}}
      {{- $haDir := printf "%s://%s/%s/ha" (trimSuffix "://" .global.storage.scheme) .global.storage.baseDir .fullname -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "high-availability.storageDir" $haDir)) -}}
    {{- end -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Add necessary java 17 compatibility configuration
*/}}
{{- define "flink-job.java17CompatibilityConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if .global.java17Compatability -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "env.java.opts.all" "--add-exports=java.base/sun.net.util=ALL-UNNAMED --add-exports=java.rmi/sun.rmi.registry=ALL-UNNAMED --add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED --add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED --add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED --add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED --add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED --add-exports=java.security.jgss/sun.security.krb5=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.text=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED --add-opens=java.base/java.util.concurrent.locks=ALL-UNNAMED")) -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Validate the configuration
*/}}
{{- define "flink-job.storageConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if and (not (eq .global.job.upgradeMode "stateless")) (not (and .global.storage.scheme .global.storage.baseDir)) -}}
    {{- fail "storage.scheme and storage.baseDir must be set when upgradeMode is not stateless" -}}
  {{- end -}}
  {{- if and .global.storage.scheme .global.storage.baseDir (has .global.job.upgradeMode (list "last-state" "savepoint")) -}}
    {{- $checkpointsDir := printf "%s://%s/%s/checkpoints" (trimSuffix "://" .global.storage.scheme) .global.storage.baseDir .fullname -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "state.checkpoints.dir" $checkpointsDir)) -}}
    {{- if eq .global.job.upgradeMode "savepoint" -}}
      {{- $savepointsDir := printf "%s://%s/%s/savepoints" (trimSuffix "://" .global.storage.scheme) .global.storage.baseDir .fullname -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "state.savepoints.dir" $savepointsDir)) -}}
    {{- end -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Set a key=value in a dictionary, if the key is not defined
*/}}
{{- define "flink-job._dictSet" -}}
  {{- $dict := index . 0 -}}
  {{- $key := index . 1 -}}
  {{- $value := index . 2 -}}
  {{- if not (hasKey $dict $key) -}}
    {{- $_ := set $dict $key $value -}}
  {{- end -}}
  {{- $dict | toJson -}}
{{- end -}}

{{- define "flink-job.sslVolumes" -}}
  {{- if $.Values.internalSsl.enabled -}}
  {{ (dict "name" "truststore" "secret" (dict "secretName" (print (include "flink-job.nameWithimageHash" . ) "-mtls-secret"))) | toYaml }}
  {{- end -}}
{{- end -}}

{{- define "flink-job.sslVolumeMounts" -}}
  {{- if $.Values.internalSsl.enabled -}}
    {{ (dict "name" "truststore" "mountPath" "/flinkkeystore" "readOnly" true) | toYaml}}
  {{- end -}}
{{- end -}}

{{- define "flink-job.nameWithimageHash" -}}
  {{ include "flink-job.fullname" . }}{{ (sha256sum (nospace (toString .Values.image))) | trunc 10 }}
{{- end -}}


{{- define "flink-job.dnsForKubernetesHostEnv" -}}
{{- if $.Values.dnsForKubernetesHost -}}
  {{ (dict "name" "KUBERNETES_SERVICE_HOST" "value" "kubernetes.default.svc.cluster.local" | toYaml) }}
{{- end }}
{{- end -}}