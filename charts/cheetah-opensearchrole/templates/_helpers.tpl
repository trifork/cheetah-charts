{{/* Define a template for creating an indexPattern */}}
{{- define "indexPattern" -}}
{{- if .Values.addSuffixWildcardToIndex -}}
{{ .Values.roleName }}*
{{- else -}}
{{ .Values.roleName }}
{{- end -}}
{{- end -}}

{{/* Define a template for creating a read roleName */}}
{{- define "roleNameRead" -}}
{{ .Values.roleName }}_read
{{- end -}}

{{- define "roleNameRead.fullname" -}}
{{ include "roleNameRead" . | replace "_" "-" }}
{{- end -}}

{{/* Define a template for creating a write roleName */}}
{{- define "roleNameWrite" -}}
{{ .Values.roleName }}_write
{{- end -}}

{{- define "roleNameWrite.fullname" -}}
{{ include "roleNameWrite" . | replace "_" "-" }}
{{- end -}}