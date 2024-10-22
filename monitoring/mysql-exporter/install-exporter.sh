#!/bin/bash

echo "Add prometheus-community helm repo first"

helm install prometheus-mysql-exporter prometheus-community/prometheus-mysql-exporter -f values.yaml --namespace monitoring
