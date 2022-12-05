{{/*Helper function to generate manager specs*/}}
{{- define "cheetah-flink-native.manager" -}}
{{ .manager }}:
  {{ if eq .manager "jobManager" -}}
  replicas: {{ .value.replicas }}
  {{- end }}
  resource:
    {{- toYaml .value.resource | nindent 4 }}

  podTemplate:
    apiVersion: v1
    kind: Pod
    metadata:
      name: {{ .manager }}-pod-template
      labels:
      {{- include "cheetah-flink-native.backstageLabels" .context | nindent 8 }}
      {{- include "cheetah-flink-native.selectorLabels" .context | nindent 8 }}
      {{- toYaml .context.Values.monitoring.podMonitorSelectorLabels | nindent 8 }}
      {{- with .value.podLabels }}
        {{ toYaml . | nindent 8 }}
      {{- end }}
      {{- with .value.podAnnotations }}
      annotations:
        {{ toYaml . | nindent 8 }}
      {{- end }}
    spec:
      containers:
        - name: flink-main-container
          ports:
          {{- if eq .manager "jobManager" }}
          - name: ui
            containerPort: {{ .context.Values.ingress.uiPort}}
          {{- end -}}
          {{- with .value.extraPorts -}}
          {{ toYaml . | nindent 10}}
          {{- end -}}
          {{- if .value.metrics.enabled }}
          - name: {{ .value.metrics.portName }}
            containerPort: {{ .value.metrics.port }}
          {{- end }}
          {{- $topicsAndEnv := concat .value.env -}}
          {{ if eq .manager "jobManager" -}}
          {{ $topicsAndEnv = concat $topicsAndEnv (.context.Values.flink.job.topics | default list) }}
          {{- end -}}
          {{- with $topicsAndEnv }}
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
        {{ toYaml . | nindent 8 }}
      {{- end }}
      {{ $imagepullsecret := default .context.Values.global.imagePullSecrets .value.imagePullSecrets }}
      {{- with $imagepullsecret -}}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  {{- end }}

