{{- define "chia.commonEnv" -}}
- name: CHIA_ROOT
  value: {{ .Values.env.chiaRoot }}
- name: ca
  value: {{ .Values.env.caPath }}
- name: TZ
  value: {{ .Values.env.timezone }}
- name: log_level
  value: {{ .Values.env.logLevel }}
- name: upnp
  value: {{ .Values.env.upnp | quote}}
{{- end }}

