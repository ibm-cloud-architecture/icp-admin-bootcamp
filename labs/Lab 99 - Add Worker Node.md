# Add a worker node to an existing cluster

In the exercise you will add a worker node to an existing IBM Cloud Private cluster.

Relevant ICP Knowledge Center section(s):
- [Add cluster node](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.2/installing/add_node.html) - for instructions for adding cluster nodes
- [Add worker node](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.2/installing/add_node.html#worker) - specific instructions for adding a worker node

# Start here

- Open a terminal session on the `boot` node.
- Login as root
- Change directories to: `/opt/ibm-cloud-private-3.1.2/cluster`.  (This is the original directory from which the cluster installation was kicked off.)
- Run the following command:
```
docker run -e LICENSE=accept --net=host \
-v "$(pwd)":/installer/cluster \
ibmcom/icp-inception-amd64:3.1.2-ee worker -l 10.10.1.3
```
The installation should take between 5 and 10 minutes.  
You can monitor the output on the screen to get a feel for what is happening.
The content you see in `stdout` is duplicated in a file in the `<ICP_HOME>/cluster/logs` directory.

- Try logging into the ICP admin console using FireFox on the boot node using the IP address of the master node (10.10.1.2).  What happens?
- You need to add `mycluster.icp` to the entry in `/etc/hosts` on the boot node for the `master` node IP address (10.10.1.2).
```
10.10.1.2  master master.ibmcloud.com mycluster.icp
```
- Now try logging into the ICP admin console using:
```
https://mycluster.icp:8443
```
- Make sure the added worker node is running.
