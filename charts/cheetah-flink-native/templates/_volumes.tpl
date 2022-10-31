{{/*Helper function to generate manager specs*/}}

{{- define "cheetah-flink-native.volume" -}}
{{- range .values }}
- name: {{ .name }}
  secret:
    secretName: {{ include "cheetah-flink-native.secretname" (dict "secret" .secret.secretName "default" (include "cheetah-flink-native.fullname" $.context)) }}
    {{- with .secret.items }}
    items:
      {{- toYaml . | nindent 4 }}
    {{- end -}}
{{- end -}}
{{- end -}}
