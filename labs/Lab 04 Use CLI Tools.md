Lab - Use CLI and Tools
---

### Table of contents
[1. Configure kubectl to connect to your ICP Cluster](#connect)

[2. Configure cloudctl to connect to your ICP Cluster](#cloudctl)

## Overview
In this lab exercise, you use the Kubernetes CLI, the IBM Cloud Private CLI, and other useful tools.

### Configure kubectl to connect to your ICP Cluster <a name="connect"></a>
The Kubernetes CLI `kubectl` has been installed for you. Use the following commands to connect it to your cluster.

1. If you are not already logged in to the ICP Admin Console from a previous exercise, on your **MASTER VM** open a browser and navigate to `https://10.10.1.2/8443`. Log in by using `username: admin` and `password: passw0rd`.

2. Click the **User** icon on the navigation bar, and then select **Configure Client** to display the commands that are used to configure a kubectl command line to connect to this ICP Cluster.

  ![Configure Client](images/kubectl/configureclient.jpg)

3. When the **Configure client** dialog displays, click the copy commands icon as shown below:

  ![Copy Commands](images/kubectl/copycommands.jpg)

4. Open a **terminal window** on the **Master VM** and paste in the commands. The output is similar to that shown below:

  ```
  # kubectl config set-cluster cluster.local --server=https://9.37.138.189:8001 --insecure-skip-tls-verify=true
  Cluster "cluster.local" set.

  # kubectl config set-context cluster.local-context --cluster=cluster.local
  Context "cluster.local-context" created.

  # kubectl config set-credentials admin --token=...
  User "admin" set.

  # kubectl config set-context cluster.local-context --user=admin --namespace=default
  Context "cluster.local-context" modified.

  # kubectl config use-context cluster.local-context
  Switched to context "cluster.local-context".
  ```

5. Issue the following command to get information about your ICP Cluster: `kubectl cluster-info`

  ```
  # kubectl cluster-info
  Kubernetes master is running at https://9.37.138.189:8001
  catalog-ui is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/catalog-ui:catalog-ui/proxy
  Heapster is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/heapster/proxy
  image-manager is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/image-manager:image-manager/proxy
  KubeDNS is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
  metrics-server is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy
  platform-ui is running at https://9.37.138.189:8001/api/v1/namespaces/kube-system/services/platform-ui:platform-ui/proxy

  To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
  ```

The **Kubernetes CLI** is now configured and is used later in the workshop.

### Use cloudctl to configure your environment <a name="bxcli"></a>
The IBM Cloud CLI `cloudctl` will configure kubectl without needing access to the ICP UI to collect the `kubectl config` parameters.

1. In a **new terminal window** the terminal window, run the following command to login into your ICP Cluster:

  ```
  cloudctl login -a https://10.10.1.2:8443
  ```

2. Enter `username: admin` and `password: passw0rd` when prompted, and select the `default namespace` as shown below.

  ```

  root@master:~# cloudctl login -a https://10.10.1.2:8443

  Username> admin

  Password>
  Authenticating...
  OK

  Targeted account mycluster Account (id-mycluster-account)

  Select a namespace:
  1. cert-manager
  2. default
  3. istio-system
  4. jenkins
  5. kube-public
  6. kube-system
  7. platform
  8. services
  Enter a number> 2
  Targeted namespace default

  Configuring kubectl ...
  Property "clusters.mycluster" unset.
  Property "users.mycluster-user" unset.
  Property "contexts.mycluster-context" unset.
  Cluster "mycluster" set.
  User "mycluster-user" set.
  Context "mycluster-context" created.
  Switched to context "mycluster-context".
  OK

  Configuring helm: /root/.helm
  OK

  ```

### Configure the Helm CLI <a name="helm"></a>
The Helm CLI has been installed for you. It has been configured by cloudctl in the previous section to connect to your ICP Cluster.

1. Run the following command to initialize the **Helm CLI**:
  ```
  helm init -c
  ```

  The results of the commands are shown below.

  ```
  # helm init -c
  Creating /root/.helm/repository
  Creating /root/.helm/repository/cache
  Creating /root/.helm/repository/local
  Creating /root/.helm/plugins
  Creating /root/.helm/starters
  Creating /root/.helm/cache/archive
  Creating /root/.helm/repository/repositories.yaml
  Adding stable repo with URL: https://kubernetes-charts.storage.googleapis.com
  Adding local repo with URL: http://127.0.0.1:8879/charts
  $HELM_HOME has been configured at /root/.helm.
  Not installing Tiller due to 'client-only' flag having been set
  Happy Helming!
  ```

2. Run the following command to list the configured Helm repositories:

  ```
  helm repo list
  ```

  The results of the commands are shown below

  ```
  # helm repo list
  NAME   	URL                                                                                                                      
  stable 	https://kubernetes-charts.storage.googleapis.com                                                                         
  local  	http://127.0.0.1:8879/charts                              
  ```

3. Run the following command to list the currently installed Helm releases:

  ```
  helm list --tls
  ```

  The **Helm CLI** is now configured, and is used later in the workshop.

#### End of Lab Review
  In this lab exercise, you installed and configured some of the command line tools that can be used with IBM Cloud Private:
  - Installed kubectl and configured it for use with your ICP Cluster
  - Installed the IBM Cloud CLI
  - Installed the Helm CLI

## End of Lab Exercise
