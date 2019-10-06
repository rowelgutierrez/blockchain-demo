kubectl delete deployments $(kubectl get deployments --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') &&
kubectl delete services ca-imfreemobile-com couchdb orderer-imfreemobile-com peer0-org1-imfreemobile-com docker &&
kubectl delete pv shared-pv &&
kubectl delete pvc shared-pvc &&
kubectl delete pvc docker-pvc --force --grace-period=0 &&
kubectl delete pv docker-pv --force --grace-period=0