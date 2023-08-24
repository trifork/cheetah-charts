{{/* Define a template for creating a read roleName */}}
{{- define "roleNameRead" -}}
{{ .Values.roleNamePrefix }}{{ .Values.roleName }}_read
{{- end -}}

{{/* Define a template for creating a write roleName */}}
{{- define "roleNameWrite" -}}
{{ .Values.roleNamePrefix }}{{ .Values.roleName }}_write
{{- end -}}

{{/* Fully qualified name used in metadata.name */}}
{{- define "roleNameRead.fullname" -}}
{{ include "roleNameRead" . | replace "_" "-" }}
{{- end -}}

{{/* Fully qualified name used in metadata.name */}}
{{- define "roleNameWrite.fullname" -}}
{{ include "roleNameWrite" . | replace "_" "-" }}
{{- end -}}