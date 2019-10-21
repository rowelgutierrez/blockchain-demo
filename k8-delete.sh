kubectl delete deployments $(kubectl get deployments --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') &&
kubectl delete services api-server ca-imfreemobile-com couchdb orderer-imfreemobile-com peer0-org1-imfreemobile-com &&

if [ "$1" = "--include-volumes" ]; then
    kubectl delete pv shared-pv &&
    kubectl delete pvc shared-pvc
fi