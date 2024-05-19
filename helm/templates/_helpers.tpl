{{- define "chia.labels" -}}
app: {{ .Chart.Name }}
{{- end -}}

{{- define "chia.selectorLabels" -}}
app: {{ .Chart.Name }}
{{- end -}}

