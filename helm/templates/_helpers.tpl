{{- define "chia.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | quote -}}
{{- else -}}
{{- .Chart.Name | quote -}}
{{- end -}}
{{- end -}}

{{- define "chia.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "chia.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

