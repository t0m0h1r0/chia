{{- define "chia.labels" -}}
app: {{ .Values.network }}-{{ .Chart.Name }}
{{- end }}

{{- define "chia.ports" -}}
{{- range $key, $value := .Values.ports }}
  - name: {{ $key }}
    containerPort: {{ $value }}
    protocol: TCP
{{- end }}
{{- end }}

{{- define "chia.commonEnv" -}}
- name: CHIA_ROOT
  value: {{ .Values.env.chiaRoot }}
- name: ca
  value: {{ .Values.env.caPath }}
- name: TZ
  value: {{ .Values.env.timezone }}
- name: log_level
  value: {{ .Values.env.logLevel }}
{{- end }}

