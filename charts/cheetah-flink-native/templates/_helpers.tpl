{{/*
Expand the name of the chart.
*/}}
{{- define "cheetah-flink-native.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cheetah-flink-native.ingresspath" -}}
{{- printf "/%s/%s%s" .Release.Namespace .Release.Name "(/|$)?(.*)" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cheetah-flink-native.fullname" -}}
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
{{- define "cheetah-flink-native.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Builds the image identifier with either sha or tag
*/}}
{{- define "cheetah-flink-native.image" -}}
{{- $repository := coalesce .Values.global.image.repository .Values.image.repository }}
{{- if .Values.image.sha }}
{{- printf "%s@sha256:%s" $repository .Values.image.sha }}
{{- else }}
{{- printf "%s:%s" $repository (.Values.image.tag | toString) }}
{{- end }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "cheetah-flink-native.labels" }}
helm.sh/chart: {{ include "cheetah-flink-native.chart" . }}
{{ include "cheetah-flink-native.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cheetah-flink-native.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cheetah-flink-native.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cheetah-flink-native.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cheetah-flink-native.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cheetah-flink-native.jobmanager-name" -}}
{{ printf "%s-rest" (include "cheetah-flink-native.fullname" . ) }}
{{- end }}

{{/*
Backstage labels
*/}}
{{- define "cheetah-flink-native.backstageLabels" -}}
backstage.io/kubernetes-id: {{ .Release.Name }}
{{- end }}

{{/*
Get the s3 main directory
*/}}
{{- define "cheetah-flink-native.s3Dir" -}}
{{- printf "s3p://flink/%s/%s" (include "cheetah-flink-native.fullname" .context) .dir -}}
{{- end }}

{{/*
PodTemplate helper function
As we have to change configuration in a list of dictionaries,
we can't make use of the `mergeOverwrite` or similar.

The flow is as following:
If `podTemplate` is defined, the pod template is started with this.
Otherwise, an empty dictionary is used as a starting point.
If `podSecurityContext` is defined, `podTemplate.spec.securityContext` is overridden

If `securityContext` is defined, we look for the "flink-main-container" container.
If it isn't found, we create it with the correct `securityContext`
*/}}
{{- define "cheetah-flink-native.podTemplate" -}}
{{- $podTemplate := (.Values.podTemplate | default dict ) -}}
{{/*update the pod security context*/}}
{{- with .Values.podSecurityContext -}}
{{- $_ := set $podTemplate.spec "securityContext" . -}}
{{- end -}}
{{/* update the container security context */}}
{{- if .Values.securityContext -}}
{{- $mainContainerIndex := -1 -}}
{{- range $i, $val := $podTemplate.spec.containers -}}
  {{- if eq $val.name "flink-main-container" -}}
  {{- $mainContainerIndex = $i -}}
  {{- end -}}
{{- end -}}
{{/* Add the flink-main-container if it does not exist */}}
{{- $containers := default list $podTemplate.spec.containers -}}
{{- if eq $mainContainerIndex -1 -}}
  {{- $containers = prepend $containers (dict "name" "flink-main-container") -}}
  {{- $mainContainerIndex = 0 -}}
{{- end -}}
{{- $mainContainer := index $containers $mainContainerIndex -}}
{{- $containers = without $containers $mainContainer -}}
{{- $_ := set $mainContainer "securityContext" .Values.securityContext -}}
{{/* Update the list of containers */}}
{{- $containers = prepend $containers $mainContainer -}}
{{- $_ := set $podTemplate.spec "containers" $containers -}}
{{- end -}}
{{- toYaml $podTemplate -}}
{{- end -}}
