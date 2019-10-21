# echo "image tag: $SHA"

# echo "Building images"
# docker build -t rowelgutierrez/fabric-api-server:latest -t rowelgutierrez/fabric-api-server:$SHA -f ./api-server/Dockerfile ./api-server
# docker build -t rowelgutierrez/fabric-workspace:latest -t rowelgutierrez/fabric-workspace:$SHA -f ./hyperledger/fabric-workspace/Dockerfile ./hyperledger/fabric-workspace

# docker push rowelgutierrez/fabric-api-server:latest
# docker push rowelgutierrez/fabric-api-server:$SHA

# docker push rowelgutierrez/fabric-workspace:latest
# docker push rowelgutierrez/fabric-workspace:$SHA

# echo "Setup k8"
# ./k8-deploy.sh

# kubectl set image deployments/api-server-deployment api-server=rowelgutierrez/fabric-api-server:$SHA
# kubectl set image deployments/cli-deployment cli=rowelgutierrez/fabric-workspace:$SHA