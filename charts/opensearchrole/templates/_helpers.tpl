{{/* 
  Define a template for creating a fully qualified roleName.
  This template takes care of truncating the roleName and delegates
  the final roleName construction to another template.
 */}}
{{- define "opensearchrole.base.resourceName" -}}
{{- $roleNamePrefix := .Values.roleNamePrefix -}}
{{- $roleName := .Values.roleName -}}
{{- $suffix := .suffix -}}

{{/* Calculate the max length allowed for roleName */}}
{{- $maxRoleNameLength := sub 64 (add (len $roleNamePrefix) (len $suffix)) | int -}}

{{/* Truncate roleName if it exceeds the max length */}}
{{- $roleName =  $roleName | trunc $maxRoleNameLength -}}

{{- include "opensearchrole.base.roleName" (dict "Values" .Values "suffix" $suffix) | replace "_" "-" -}}
{{- end -}}

{{/* 
  Define a template for creating an indexPattern. 
  If indexPattern is not provided in .Values, the roleName is used as the indexPattern.
 */}}
{{- define "opensearchrole.indexPattern" -}}
{{- if .Values.indexPattern -}}
  {{ .Values.indexPattern }}
{{- else -}}
  {{ .Values.roleName }}
{{- end -}}
{{- end -}}

{{/* 
  Define a template for creating a roleName with either a _read or _write suffix.
  This template is responsible for assembling the roleName.
 */}}
{{- define "opensearchrole.base.roleName" -}}
{{- $roleNamePrefix := .Values.roleNamePrefix -}}
{{- $roleName := required "roleName is required" .Values.roleName -}}
{{- $suffix := required "suffix is required" .suffix -}}

{{/* Check that the suffix is either "read" or "write" */}}
{{- if or (eq $suffix "read") (eq $suffix "write") -}}
  {{- printf "%s%s_%s" $roleNamePrefix $roleName $suffix -}}
{{- else -}}
  {{- fail "Suffix must be either 'read' or 'write'" -}}
{{- end -}}
{{- end -}}

{{/* Define a convenience template for read-only role resources */}}
{{- define "opensearchrole.resourceName.read" -}}
{{- include "opensearchrole.base.resourceName" (dict "Values" .Values "suffix" "read") -}}
{{- end -}}

{{/* Define a convenience template for write-enabled role resources */}}
{{- define "opensearchrole.resourceName.write" -}}
{{- include "opensearchrole.base.resourceName" (dict "Values" .Values "suffix" "write") -}}
{{- end -}}

{{/* Define a convenience template for read-only roleNames */}}
{{- define "opensearchrole.roleName.read" -}}
{{- include "opensearchrole.base.roleName" (dict "Values" .Values "suffix" "read") -}}
{{- end -}}

{{/* Define a convenience template for write-enabled roleNames */}}
{{- define "opensearchrole.roleName.write" -}}
{{- include "opensearchrole.base.roleName" (dict "Values" .Values "suffix" "write") -}}
{{- end -}}
