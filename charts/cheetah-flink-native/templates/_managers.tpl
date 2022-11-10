{{/*Helper function to generate manager specs*/}}
{{- define "cheetah-flink-native.manager" -}}
{{ .manager }}:
  replicas: {{ .value.replicas }}
  resource: 
    {{- toYaml .value.resource | nindent 4 }}

  podTemplate:
    apiVersion: v1
    kind: Pod
    metadata:
      name: {{ .manager }}-pod-template
      {{- with .value.podLabels }}
      labels:
        {{ toYaml . | nindent 6 }}
      {{- end }}
      {{- with .value.podAnnotations }}
      annotations:
        {{ toYaml . | nindent 6 }}
      {{- end }}
    spec:
      containers:
        - name: flink-main-container
          ports:
          {{- with .value.metrics.extraPorts -}}
          {{ toYaml . | nindent 10}}
          {{- end -}}
          {{- if .value.metrics.enabled }}
          - name: metrics
            containerPort: 9249
          {{- end }}

          {{- with .value.env -}}
          env:
          {{- toYaml . | nindent 10 }}
          {{- end }}

          {{- with .value.volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 10 }}
          {{- end }}

          {{- with .value.additionalConfigs -}}
          {{- toYaml . | nindent 8 }}
          {{- end }}
      {{ with .value.volumes -}}
      volumes:
        {{- include "cheetah-flink-native.volume" (dict "values" . "context" $.context) | nindent 6 }}
      {{- end }}
      {{ $imagepullsecret := default .context.Values.global.imagePullSecrets .value.imagePullSecrets }}
      {{- with $imagepullsecret -}}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  {{- end }}

