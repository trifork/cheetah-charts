{{/*
  Helper function to generate jobManger spec
  see https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-release-1.0/docs/custom-resource/reference/#jobmanagerspec
*/}}
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
            {{- toYaml .value.metrics.extraPorts | nindent 12 }}
          {{- end }}
          env:
            {{- if .context.Values.flink.savepoints.enabled }}
            {{- include "cheetah-flink-native.storageConfig" .context | nindent 12 -}}
            {{- end }}

          {{- with .value.additionalConfigs }}
          {{- toYaml . | nindent 10 }}
          {{- end }}

          volumeMounts:
          {{- with .value.volumeMounts }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
            - name: s3-config
              mountPath: /opt/flink/conf/extra

      volumes:
      {{- with .value.volumes }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
        - name: s3-config
          secret:
            secretName: {{ include "cheetah-flink-native.fullname" .context }}-s3
            items:
              - key: test.yaml
                path: test.yaml


{{- end -}}



{{/*
  Helper function to generate taskManger spec
  see https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-release-1.0/docs/custom-resource/reference/#jobmanagerspec
*/}}
{{- define "cheetah-flink-native.task-manager" -}}
taskManager:

  resource:
    {{- toYaml .value.resource | nindent 4 }}

  podTemplate:
    apiVersion: v1
    kind: Pod
    metadata:
      name: task-manager-pod-template
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
            {{- toYaml .value.metrics.extraPorts | nindent 12 }}
          {{- end }}
          env:
            {{- if .context.Values.flink.savepoints.enabled }}
            {{- include "cheetah-flink-native.storageConfig" .context | nindent 12 -}}
            {{- end }}

          {{- with .value.additionalConfigs }}
          {{- toYaml . | nindent 10 }}
          {{- end }}

        {{- with .value.volumeMounts }}
        volumeMounts:
          {{- toYaml . | nindent 6 }}
        {{- end }}

    {{- with .value.volumes }}
    volumes:
      {{- toYaml . | nindent 6 }}
    {{- end }}
{{- end -}}
