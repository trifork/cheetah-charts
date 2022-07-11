{{- define "cheetah-flink-native.job-manager" -}}
jobManager:
  replicas: {{ .value.replicas }}

  resource:
    {{- toYaml .value.resource | nindent 4 }}

  podTemplate:
    apiVersion: v1
    kind: Pod
    metadata:
      name: job-manager-pod-template
      {{- with .value.podLabels }}
      labels:
        {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- with .value.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    spec:
      containers:
        - name: flink-main-container
          {{- if .value.metrics.enabled }}
          ports:
            {{- toYaml .value.metrics.extraPorts | nindent 10 }}
          {{- end }}
          env:
            {{- if .context.Values.flink.savepoints.enabled }}
            {{ include "cheetah-flink-native.storageCredentials" .context | nindent 8}}
            {{- end }}

        {{- with .value.volumeMounts }}
        volumeMounts:
          {{- toYaml . | nindent 6}}
        {{- end }}

    {{- with .value.volumes }}
    volumes:
      {{- toYaml . | nindent 6}}
    {{- end }}

{{- with .value.additionalConfigs }}
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}