Error message: Unauthenticated desc = invalid session: Token is expired 

Fix: argocd login 127.0.0.1:8080


argocd cluster add docker-desktop
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `docker-desktop` with full cluster level privileges. Do you want to continue [y/N]?yu
INFO[0003] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0003] ClusterRole "argocd-manager-role" updated    
INFO[0003] ClusterRoleBinding "argocd-manager-role-binding" updated 
FATA[0003] rpc error: code = Unauthenticated desc = invalid session: Token is expired 

Error message: InvalidArgument desc = existing cluster spec is different; use upsert flag to force update; difference in keys

argocd cluster add docker-desktop  
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `docker-desktop` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0002] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0002] ClusterRole "argocd-manager-role" updated    
INFO[0002] ClusterRoleBinding "argocd-manager-role-binding" updated 
FATA[0002] rpc error: code = InvalidArgument desc = existing cluster spec is different; use upsert flag to force update; difference in keys

argocd cluster list 
SERVER                                   NAME            VERSION  STATUS   MESSAGE                                                  PROJECT
https://kubernetes.docker.internal:6443  docker-desktop           Unknown  Cluster has no applications and is not being monitored.  
https://kubernetes.default.svc           in-cluster               Unknown  Cluster has no applications and is not being monitored.  

Fix: argocd cluster add docker-desktop --upsert

Verification
argocd cluster list                       
SERVER                                   NAME            VERSION  STATUS      MESSAGE                                                  PROJECT
https://kubernetes.docker.internal:6443  docker-desktop  1.25     Successful                                                           
https://kubernetes.default.svc           in-cluster               Unknown     Cluster has no applications and is not being monitored.  


Unable to load data: Request has been terminated Possible causes: the network is offline, Origin is not allowed by Access-Control-Allow-Origin, the page is being unloaded, etc.