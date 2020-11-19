# !/bin/bash
echo "Deploying production \n"
kubectl apply -f production
kubectl rollout status deployment.v1.apps/cop-demo-api
echo "Production deployed\n"

echo "Performing canary deploy\n"
kubectl apply -f canary
kubectl rollout status deployment.v1.apps/cop-demo-api-canary

echo "Canary deployed"
echo "Wait for some time to allow the canary to get some production traffic\n"
sleep 5

echo "Sending some requests that will cause errors for the sake of the demo...\n"
for i in {1..20}
do
    curl https://api.subdomain.com/demo/error
done

echo
echo "Checking to see if the canary has ran with less than 5 errors...\n"
POD=$(kubectl get pod -l track=canary -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward -n syndicationservices $POD 3000 &

sleep 10
ERRORS=$(curl -s http://localhost:3000/demo/metrics | jq '.metrics["500"]')

if [ $ERRORS -ge 2 ]
then
    echo "\nUh oh looks there were ${ERRORS} errors on your canary\n"
    kubectl delete -f canary
else
    echo "\nCanary is healthy\n"
    sed -i -e 's/v10/v20/g' ./production/deployment.yml
    kubectl apply -f production
    kubectl rollout status deployment.v1.apps/cop-demo-api
    kubectl delete -f canary
fi







# Put the version back down so my demo is repeatable lol
sed -i -e 's/v20/v10/g' ./production/deployment.yml
