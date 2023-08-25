{{/* Define a template for creating an indexPattern */}}
{{- define "indexPattern" -}}
{{- if .Values.indexPattern -}}
{{ .Values.indexPattern }}*
{{- else -}}
{{ .Values.roleName }}
{{- end -}}
{{- end -}}

{{/* Define a template for creating a read roleName */}}
{{- define "roleNameRead" -}}
{{- printf "%s%s_read" .Values.roleNamePrefix (required "roleName is required" .Values.roleName) -}}
{{- end -}}

{{/* Define a template for creating a write roleName */}}
{{- define "roleNameWrite" -}}
{{- printf "%s%s_write" .Values.roleNamePrefix (required "roleName is required" .Values.roleName) -}}
{{- end -}}

{{/* Fully qualified name used in metadata.name */}}
{{- define "roleNameRead.fullname" -}}
{{ include "roleNameRead" . | replace "_" "-" }}
{{- end -}}

{{/* Fully qualified name used in metadata.name */}}
{{- define "roleNameWrite.fullname" -}}
{{ include "roleNameWrite" . | replace "_" "-" }}
{{- end -}}