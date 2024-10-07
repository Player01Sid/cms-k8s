# Custom Configurations of ArgoCD

## Configuring Healthy status of Ingress
Add following lines *argocd-cm* configmap
```yaml
apiVersion: v1
data:
  resource.customizations: |
    extensions/Ingress:
      health.lua: |
        hs = {}
        if obj.status ~= nil then
          hs.status = "Healthy"
        end
        return hs
    networking.k8s.io/Ingress:
      health.lua: |
        hs = {}
        if obj.status ~= nil then
          hs.status = "Healthy"
        end
        return hs
kind: ConfigMap
metadata:
...
```
## Configuring argocd-server without tls
Follow the steps to configure server to host without TLS.
- Add following lines to *argocd-cmd-params-cm* configmap
```yaml
  apiVersion: v1
  data:
    server.insecure: "true"
  kind: ConfigMap
  metadata:
  ...
```
- Restart argocd-server deployment
```bash
  kubectl rollout restart deployment argocd-server -n argocd
```
