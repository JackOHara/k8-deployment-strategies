# Kubernetes Deployments
Here are four examples of deployment strategies that kubernetes provides out of the box. To use these in your own cluster change the namespace in the .yamls to yours and configure the TLS and host in the ingress. You will also need to change the image in deployment.yml to point to a local image or an image registry. 


## Recreate Deployments
When redeployed this will kill all pods and then bring up new ones. 
```
kubectl apply -f recreate/
```

## Rolling Deployments
When redeployed this will kill one pod at a time and bring up one pod at a time to replace it. 
```
kubectl apply -f recreate/
```

## Blue/Green Deployments
This will deploy a production stack (green) which traffic will be directed to. It will then bring up a new stack (blue). When our new stack is ready to go live we can update the service to direct traffic to blue instead of green. 
```
kubectl apply -f blue-green/green/
kubectl rollout status deployment.v1.apps/cop-demo-api-green

kubectl apply -f blue-green/blue/
kubectl rollout status deployment.v1.apps/cop-demo-api-blue

# Point the service at the green stack
sed -i -e 's/1.0/2.0/g' ./blue-green/blue/service.yml

kubectl apply -f blue-green/blue/
```

## Canary
This script deploys a production stack. Waits for it to complete deployment and then deploys a canary. It then sends some bad requests to the API (for the sake of the demo). The number of 500s on the canary is used to determine whether we should roll back or roll out fully. 
```
cd canary
./deploy.sh
```