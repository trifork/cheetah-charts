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
{{- end -}}

{{/*
Get the savepoint directories
*/}}
{{- define "flink-job.storage-configuration" -}}
{{ $prefix := (include "flink-job.storage-prefix" . ) }}
{{ $fullname := (include "flink-job.fullname" . ) }}
{{- if not (hasKey .Values.flink.configuration "state.savepoints.dir" ) }}
state.savepoints.dir: {{ printf "%s://flink/%s/savepoints" $prefix $fullname }}
{{- end }}
{{- if not (hasKey .Values.flink.configuration "state.checkpoints.dir" ) }}
state.savepoints.dir: {{ printf "%s://flink/%s/checkpoints" $prefix $fullname }}
{{- end }}
{{- if not (hasKey .Values.flink.configuration "high-availability.storageDir" ) }}
state.savepoints.dir: {{ printf "%s://flink/%s/ha" $prefix $fullname }}
{{- end }}
{{- end -}}

{{- define "flink-job.storage-prefix" -}}
{{- if .Values.flink.s3.enabled }}
s3p
{{- else }}
file
{{- end }}
{{- end -}}

