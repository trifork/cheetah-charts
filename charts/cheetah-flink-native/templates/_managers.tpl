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
          {{ if and (.context.Values.flink.ui.enabled) (eq .manager "jobManager") -}}
          - name: ui
            containerPort: {{ .context.Values.flink.ui.port }}
          {{- end -}}
          {{- with .value.extraPorts -}}
          {{ toYaml . | nindent 10}}
          {{- end -}}
          {{- if .value.metrics.enabled }}
          - name: {{ .value.metrics.portName }}
            containerPort: {{ .value.metrics.port }}
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
        {{ toYaml . | nindent 8 }}
      {{- end }}
      {{ $imagepullsecret := default .context.Values.global.imagePullSecrets .value.imagePullSecrets }}
      {{- with $imagepullsecret -}}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  {{- end }}

