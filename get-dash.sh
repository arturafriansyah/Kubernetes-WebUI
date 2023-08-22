#!/bin/bash
#
# IRSOLS Inc 2019-2021
# Small script to get K8s Dashboard URL and credential token
# This is required for multi-host cluster where K8s can randomly
# assign dashboard pods to any node in the cluster .
# First version : Aug 2019
# Last modified : Dec 2020

#!/bin/bash

# Check if the deployment uses k3d
k3d=$(docker ps | grep server-0 | wc -l)

# if output is 1 or true 
if [ "$k3d" -eq 1 ]; then

  export DASH_NODE_NAME=`kubectl get nodes | grep server-0 | awk '{print 1}'`
  export DASH_NODE_IP=`kubectl describe nodes k3d-k3s-default-server-0 | grep InternalIP | awk '{print $2}'`
  export DASH_NODE_PORT=`kubectl get svc -A | grep -i kubernetes-dashboard | grep "443:" | awk '{print $6}' | sed  's/443//' | sed 's/\/TCP//'`
  export TOKEN=`kubectl -n kubernetes-dashboard create token admin-user`
  echo "Your Dashboard with Nodeport URL is: https://$DASH_NODE_IP$DASH_NODE_PORT/"
  echo
  echo "Token: $TOKEN"
  echo

else

  export DASH_NODE_NAME=`kubectl get pods  --all-namespaces -o wide | grep "kubernetes-dashboard-" | awk {'print $8'}`
  export DASH_NODE_IP=`grep $DASH_NODE_NAME /etc/hosts | awk {'print $1'}`
  export DASH_NODE_PORT=` kubectl get services  --all-namespaces -o wide | grep "443:" | awk {'print $6'} | sed  's/443//' | sed 's/\/TCP//'`
  export TOKEN=`kubectl -n kubernetes-dashboard create token admin-user`
  echo "Your Dashboard with Nodeport URL is: https://$DASH_NODE_IP$DASH_NODE_PORT/"
  echo
  echo "Token: $TOKEN"
  echo
fi
