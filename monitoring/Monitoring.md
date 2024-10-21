# Installation

CHART : prometheus-community/kube-prometheus-stack
VALUES:
``` yaml
prometheus:
  prometheusSpec:
    podMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelectorNilUsesHelmValues: false

alertmanager:
  config:
    global:
      slack_api_url: https://hooks.slack.com/services/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
  alertmanagerSpec:
    replicas: 2
    alertmanagerConfigNamespaceSelector:
    alertmanagerConfigSelector:
    alertmanagerConfigMatcherStrategy:
      type: None
```

## Prometheus Rule
``` yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  annotations:
    meta.helm.sh/release-name: kube-prometheus-stack
    meta.helm.sh/release-namespace: monitoring
    prometheus-operator-validated: "true"
  labels:
    app: kube-prometheus-stack
    app.kubernetes.io/instance: kube-prometheus-stack
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/part-of: kube-prometheus-stack
    app.kubernetes.io/version: 65.2.0
    heritage: Helm
    release: kube-prometheus-stack
  name: cms-prometheus-rules
  namespace: monitoring
spec:
  groups:
  - name: cms-alerts
    rules:
    - alert: cms-memory-alert
      annotations:
        description: "Value of {{ $labels.metric }} exceeded than 90000000."
        summary: "Memory consumed by CMS exceeded 600MB."
      expr: sum(container_memory_rss) > 90000000
      for: 30s
      labels:
        severity: critical
        metric: "sum(container_memory_rss)"

```

## Alert Manager Configuration
``` yaml
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: global-alert-manager-configuration
  namespace: monitoring
  labels:
    release: kube-prometheus-stack
spec:
  receivers:
    - name: slack-notifications
      slackConfigs:
        - channel: "#prometheus-alert-webhook"
          sendResolved: true
          iconEmoji: ":bell:"
          text: "<!channel> \nsummary: {{ .CommonAnnotations.summary }}\ndescription: {{ .CommonAnnotations.description }}\nmessage: {{ .CommonAnnotations.message }}"
  route:
    matchers:
      - name: severity
        value: critical
    receiver: slack-notifications
    repeatInterval: 1s

```

# Home ServiceMonitor
``` yaml

