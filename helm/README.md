# Compiling k8s manifests using Helm

0. Update config in `dokuwiki/values.yaml`
1. Generate the manifests using: ```helm template --values ./dokuwiki/values.yaml --output-dir ./manifests ./dokuwiki```
2. Check the manifests with a dry run: ```kubectl apply --recursive --filename ./manifests/dokuwiki --dry-run```
