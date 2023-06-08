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
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
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
app.kubernetes.io/component: metrics
{{ include "flink-job.labels" . }}
{{ include "flink-job.backstageLabels" . }}
{{ with .Values.metrics.podMonitor.selectors -}}
  {{- toYaml . }}
{{- end }}
{{ with .Values.podLabels -}}
  {{- toYaml . }}
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

{{/*
Backstage labels
*/}}
{{- define "flink-job.backstageLabels" -}}
backstage.io/kubernetes-id: {{ .Release.Name }}
{{ include "flink-job.topicLabels" . }}
{{- end -}}

{{- define "flink-job.topicLabels" -}}
{{- $inputs := "" -}}
{{- $outputs := "" -}}
{{- range .Values.job.topics -}}
  {{- if eq .type "input" -}}
    {{- $inputs = printf "%s,%s" $inputs .name -}}
  {{- else if eq .type "output" -}}
    {{- $outputs = printf "%s,%s" $outputs .name -}}
  {{- else -}}
    {{- fail (printf "Topic type %s not understood. Allowed values are: input, output" .type) -}}
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
  {{- toYaml $configs -}}
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
    {{- else if eq "v1_16" .global.version -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "metrics.reporter.prom.factory.class" "org.apache.flink.metrics.prometheus.PrometheusReporterFactory")) -}}
    {{- end -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Add necessary configuration for running in HA mode
*/}}
{{- define "flink-job.haConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if gt (int .global.jobManager.replicas) 1 -}}
    {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "high-availability" "org.apache.flink.kubernetes.highavailability.KubernetesHaServicesFactory")) -}}
    {{- if and .global.storage.scheme .global.storage.baseDir -}}
      {{- $haDir := printf "%s://%s/%s/ha" .global.storage.scheme .global.storage.baseDir .fullname -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "high-availability.storageDir" $haDir)) -}}
    {{- end -}}
    {{- if not (hasKey $configs "high-availability.storageDir") -}}
      {{- fail "storage.scheme and storage.baseDir or flinkConfiguration.'high-availability.storageDir' is required when using jobManager.replicas > 1" -}}
    {{- end -}}
  {{- end -}}
  {{- $configs | toJson -}}
{{- end -}}

{{/*
Validate the configuration
*/}}
{{- define "flink-job.storageConfiguration" -}}
  {{- $configs := .configs -}}
  {{- if not (has .global.job.upgradeMode (list "stateless" "last-state" "savepoint")) -}}
    {{- fail "job.upgradeMode must be either stateless, last-state, or savepoint" -}}
  {{- end -}}
  {{- if has .global.job.upgradeMode (list "savepoint" "last-state") -}}
    {{- if and .global.storage.scheme .global.storage.baseDir -}}
      {{- $savepointsDir := printf "%s://%s/%s/savepoints" .global.storage.scheme .global.storage.baseDir .fullname -}}
      {{- $checkpointsDir := printf "%s://%s/%s/checkpoints" .global.storage.scheme .global.storage.baseDir .fullname -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "state.savepoints.dir" $savepointsDir)) -}}
      {{- $configs = fromJson (include "flink-job._dictSet" (list $configs "state.checkpoints.dir" $checkpointsDir)) -}}
    {{- end -}}
    {{- if not (hasKey $configs "state.savepoints.dir") -}}
      {{- fail "storage.scheme and storage.baseDir or flinkConfiguration.'state.savepoints.dir' is required when using job.upgradeMode=savepoint or last-state" -}}
    {{- end -}}
    {{- if not (hasKey $configs "state.checkpoints.dir") -}}
      {{- fail "storage.scheme and storage.baseDir or flinkConfiguration.'state.checkpoints.dir' is required when using job.upgradeMode=savepoint or last-state" -}}
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
