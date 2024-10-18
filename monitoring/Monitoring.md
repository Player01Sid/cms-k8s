# Installation

CHART : prometheus-community/kube-prometheus-stack
VALUES:
``` yaml
alertmanager:
  alertmanagerSpec:
    replicas: 2
```

# Prometheus Rule
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

# Alert Manager Configuration
``` yaml
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: config-example
  labels:
    alertmanagerConfig: example
spec:
  route:
    groupBy: ['job']
    groupWait: 30s
    groupInterval: 5m
    repeatInterval: 12h
    receiver: 'webhook'
  receivers:
  - name: 'webhook'
    webhookConfigs:
    - url: 'http://example.com/'

```