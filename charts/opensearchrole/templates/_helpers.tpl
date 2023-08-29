{{/* Define a template for creating a fully qualified roleName */}}
{{- define "opensearchrole.base.resourceName" -}}
{{- $roleNamePrefix := .Values.roleNamePrefix -}}
{{- $roleName := .Values.roleName -}}
{{- $suffix := .suffix -}}
{{- $dict := dict "Values" .Values "suffix" $suffix -}}

{{/* Calculate the max length allowed for roleName */}}
{{- $maxRoleNameLength := sub 64 (add (len $roleNamePrefix) (len $suffix)) -}}

{{/* Truncate roleName if it exceeds the max length */}}
{{- if gt (len $roleName) $maxRoleNameLength -}}
  {{- $roleName = slice $roleName 0 $maxRoleNameLength -}}
{{- end -}}

{{- include "opensearchrole.base.roleName" $dict  | replace "_" "-" -}}
{{- end -}}

{{/* Define a template for creating an indexPattern */}}
{{- define "opensearchrole.indexPattern" -}}
{{- if .Values.indexPattern -}}
  {{ .Values.indexPattern }}
{{- else -}}
  {{ .Values.roleName }}
{{- end -}}
{{- end -}}

{{/* Define a template for creating a roleName with _read or _write */}}
{{- define "opensearchrole.base.roleName" -}}
{{- $roleNamePrefix := .Values.roleNamePrefix -}}
{{- $roleName := required "roleName is required" .Values.roleName -}}
{{- $suffix := required "suffix is required" .suffix -}}

{{/* Check that the suffix is either read or write */}}
{{- if or (eq $suffix "read") (eq $suffix "write") -}}
  {{- printf "%s%s_%s" $roleNamePrefix $roleName $suffix -}}
{{- else -}}
  {{- fail "Suffix must be either 'read' or 'write'" -}}
{{- end -}}
{{- end -}}

{{- define "opensearchrole.resourceName.read" -}}
{{- $dict := dict "Values" .Values "suffix" "read" -}}
{{- include "opensearchrole.base.resourceName" $dict -}}
{{- end -}}

{{- define "opensearchrole.resourceName.write" -}}
{{- $dict := dict "Values" .Values "suffix" "write" -}}
{{- include "opensearchrole.base.resourceName" $dict -}}
{{- end -}}

{{- define "opensearchrole.roleName.read" -}}
{{- $dict := dict "Values" .Values "suffix" "read" -}}
{{- include "opensearchrole.base.roleName" $dict -}}
{{- end -}}

{{- define "opensearchrole.roleName.write" -}}
{{- $dict := dict "Values" .Values "suffix" "write" -}}
{{- include "opensearchrole.base.roleName" $dict -}}
{{- end -}}