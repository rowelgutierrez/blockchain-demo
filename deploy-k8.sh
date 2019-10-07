echo "Starting cluster"

K8_DIR=test.k8s

if [ "$1" = "minikube" ] && [ "$2" = "new" ]; then
    minikube stop && minikube delete && minikube start --cpus 4 --memory 8192 --vm-driver hyperkit
fi

kubectl apply -f $K8_DIR/setup.yaml
AVAILABLE=$(kubectl get deployments | grep cli-deployment | awk '{print $4}')
while [ "${AVAILABLE}" = "0" ]; do
    echo "Waiting for cli-deployment to be available"
    kubectl get pods
    AVAILABLE=$(kubectl get deployments | grep cli-deployment | awk '{print $4}')
    sleep 1
done

kubectl apply -f $K8_DIR/
NUMPENDING=$(kubectl get deployments | grep deployment | awk '{print $4}' | grep 0 | wc -l | awk '{print $1}')
while [ "${NUMPENDING}" != "0" ]; do
    echo "Waiting on pending deployments. Deployments pending = ${NUMPENDING}"
    kubectl get pods
    NUMPENDING=$(kubectl get deployments | grep deployment | awk '{print $4}' | grep 0 | wc -l | awk '{print $1}')
    sleep 1
done

echo "All Done"