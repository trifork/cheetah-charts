{{/*
Expand the name of the chart.
*/}}
{{- define "cheetah-flink.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Hostname to expose flink ui on
*/}}
{{- define "cheetah-flink.hostname" -}}
{{- printf "%s-%s.%s" (.Release.Name) (.Release.Namespace) .Values.ingress.domain }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cheetah-flink.fullname" -}}
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
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cheetah-flink.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Builds the image identifier with either sha or tag
*/}}
{{- define "cheetah-flink.image" -}}
{{- $repository := coalesce .Values.global.image.repository .Values.image.repository }}
{{- if .Values.image.sha }}
{{- printf "%s@sha256:%s" $repository .Values.image.sha }}
{{- else }}
{{- printf "%s:%s" $repository .Values.image.tag }}
{{- end }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "cheetah-flink.labels" -}}
helm.sh/chart: {{ include "cheetah-flink.chart" . }}
{{ include "cheetah-flink.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cheetah-flink.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cheetah-flink.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cheetah-flink.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cheetah-flink.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cheetah-flink.jobmanager-name" -}}
{{ printf "%s-jobmanager" (include "cheetah-flink.fullname" . ) }}
{{- end }}

{{/*
Get the savepoints directory
*/}}
{{- define "cheetah-flink.storageDir" -}}
{{- $dir := printf "s3p://flink/%s" (include "cheetah-flink.fullname" . ) -}}
{{- if gt (int64 .Values.flink.savepoints.generation) 0 }}
{{- $dir = printf "%s-%v" $dir .Values.flink.savepoints.generation }}
{{- end }}
{{- $dir }}
{{- end }}
