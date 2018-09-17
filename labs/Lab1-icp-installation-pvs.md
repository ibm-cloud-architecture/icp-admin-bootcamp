Lab Exercise: Install IBM Cloud Private
=========================================================================

In this exercise you will install IBM Cloud Private v2.1.0.3

# Prerequisites

**This section is for your information.  There are no steps in this section that you need to take.  You can go look at things to confirm they are as described, but you don't need to do anything.**

If you want to skip this section and get started, go to the [Start here](#Start here) section below.

A collection of virtual machines (VMs) has been provided for your use in this lab exercise.  

- One of the machines is referred to as the `boot` (`icpboot`) machine, meaning it is the machine that is used to orchestrate the installation. The boot machine is not part of the ICP cluster.  
- The other 7 machines will be assigned the roles of:
  - master
  - management
  - proxy
  - vulnerability advisor (VA)
  - and worker
- The collection of machines makes up what is referred to as a `cluster`.
- The cluster you will be working with has 3 `worker` nodes.
- All VMs are running CentOS v7.5.  We choose to use CentOS for the ICP bootcamp because virtually all IBM customers using Linux are using RHEL.  CentOS is the public distribution that is the basis for RHEL.  CentOS also has the advantage of having public `yum` repositories to make it easy to install and configure with the packages needed for the bootcamp.
- The boot and master VM has a GUI interface.  The 6 other cluster member VMs have only a command line interface.
- All machines have an `icp` user (ICP Maestro) with password: `passw0rd`.
- The `root` password on all machines is `passw0rd`.
- The boot node is running an NFS server that is exporting `/storage`
- The boot node is also running an OpenLDAP server.  (An LDAP lab exercise uses an OpenLDAP running in a container.)

- The `/etc/hosts` file on each VM is configured with the proper entries so that each VM can resolve the address of the other members of the cluster.
```
10.0.0.1		icpboot.icp.local
10.0.0.2		master01.icp.local
10.0.0.3		mgmt01.icp.local
10.0.0.4		va01.icp.local
10.0.0.5		proxy01.icp.local
10.0.0.6		worker01.icp.local
10.0.0.7		worker02.icp.local
10.0.0.8		worker03.icp.local
```

- SSH has been configured such that the boot VM can `ssh` as `root` to each of the other VMs in the cluster (including itself) without using a password. **You do not need to run through the steps to configure passwordless SSH.** The steps to configure passwordless SSH for a collection of machines is described in [Configure Passwordless SSH](configure-passwordless-ssh.md)

- Ansible is installed on the boot machine.  The `/etc/ansible/hosts` file has been configured to include the machines in your cluster.  To check that Ansible is configured properly use: `ansible -m ping icp`.  You should see a response from each machine including the boot machine.

```
[icp]
icpboot.icp.local
master01.icp.local
mgmt01.icp.local
proxy01.icp.local
va01.icp.local
worker01.icp.local
worker02.icp.local
worker03.icp.local

[masters]
master01.icp.local

[mgmt]
mgmt01.icp.local

[proxies]
proxy01.icp.local

[va]
va01.icp.local

[workers]
worker01.icp.local
worker02.icp.local
worker03.icp.local
```

- The product install archive is available on the boot machine in `/root/icp2103`. Outside of this class, you would need to download the product archives from Passport Advantage (IBM customer) or eXtreme Leverage (IBM internal).  You can find the GA releases by searching on, *IBM Cloud Private*.

- You also need to download the Docker installation executable from Passport Advantage or eXtreme Leverage. However for CentOS the Docker install executable fails to install Docker.  In this lab exercise you will install the proper build of Docker from the CentOS yum repository for Docker builds.

- In `/root/playbooks` are several Ansible playbooks that are used during in the install. (Some additional playbooks that are not used as part of this installation process are also collected in the `playbooks` directory.)

```
copy-pki-artifacts.yaml      
install-docker-centos.yaml
start-firewalld.yaml
stop-firewalld.yaml
```

- In the steps below where `ansible-playbook` is run, it is assumed to be run from the `/root/playbooks` directory.  You can run the command from anywhere if you provide the full path to the playbook.

- As part of the preparation for doing the installation for this exercise, a private Docker registry was configured on the `icpboot` machine.  **You do not need to go through the steps to configure this registry.**  The configuration steps are documented in [Configure a Private Docker Repository for IBM Cloud private Native or Enterprise Installation](install-from-private-docker-registry.md).  This approach can only be used when you are installing to a homogeneous cluster, i.e., all `x86` nodes or all `ppc` nodes.  This approach cannot be used in a cluster with `s390x` (zLinux) worker nodes.  Using a private Docker registry to do the ICP installation reduces the installation time dramatically by eliminating the steps of copying the ICP image tar ball to all the machines in the cluster.  

- On all VMs in the ICP cluster, if `firewalld` is running, stop it and disable it until after the ICP install completes.  (Use the ansible playbook to stop and disable the firewall on each VM.)

# Start here

**Step 0: You MUST `sudo root` on the `boot node` before proceeding any further.**
```
sudo su -
```
Going forward is you do not see the `#` prompt then you are not `root` and you need to `sudo` to become root.

**Step 1: Execute this command to stop `firewalld`**

*NOTE:* This step has already been done.  Go ahead and run it. The Ansible results should show that state has not changed on the target nodes.

```
cd /root/playbooks
ansible-playbook stop-firewalld.yaml --extra-vars "target_nodes=icp"
```

*NOTE:* In a realistic deployment, the firewall only needs to be disabled during install.  It gets enabled again on all members of the cluster after the install has completed. **However, for the duration of this course we are leaving the firewall stopped and disabled.**  

*NOTE:* In a scenario where an ICP cluster's VMs (members) are on more than one network segment/VLAN, there may be physical firewalls that need to be configured to allow the ICP installation to proceed. See the ICP Knowledge Center section, [Default ports](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_2.1.0.3/supported_system_config/required_ports.html), for the list of ports that must be open for installation and configuration of an ICP instance.


**Step 2: Execute this command to run the Ansible playbook to install, start, enable Docker on all of the target cluster nodes:**
```
ansible-playbook install-docker-centos.yaml --extra-vars "target_nodes=icp docker_build=docker-ce-17.12.1.ce-1.el7.centos.x86_64"
```

- One of the steps that allows the use of the private docker registry needs to be completed.  An Ansible playbook is used to copy the PKI artifacts to the `/etc/docker/certs.d/icpboot.icp.local:8500` on each machine.

**Step 3: Execute this command to copy the PKI artifacts:**

*NOTE:* This step has been run for you.  You can skip it, or you can run it again if you want to.  The Ansible output should confirm that the PKI files were already copied to the proper location.

```
ansible-playbook copy-pki-artifacts.yaml --extra-vars "target_nodes=icp registry_host=icpboot.icp.local:8500"
```

## Some additional boot node pre-installation steps

This section has some steps that need to be taken on the boot before the actual installation command can be run. You must be logged in as `root`.

*NOTE:* In these instructions, the root directory of the installation is referred to as `<ICP_HOME>`.  A common convention is to install ICP in a directory that includes the ICP version in the directory name, e.g., `/opt/icp2103`.

**Step 1: Execute this command to create the installation directory**
```
mkdir /opt/icp2103
```

**Step 2: Read and follow these instructions.** Docker has been installed on the `icpboot` node.  It should be running. You can confirm that it is with `systemctl status docker`.  If it is not running, then start it with `systemctl start docker` and check that it is running.

**Step 3: On the `icpboot` node, execute these commands to extract the ICP boot meta-data to the `/opt/icp2103/` directory:**
```
cd /opt/icp2103
docker run -v $(pwd):/data -e LICENSE=accept icpboot.icp.local:8500/ibmcom/icp-inception:2.1.0.3-ee cp -r cluster /data  
```
**Step 4: Read and follow these instructions.** The `icp-inception` image gets a different tag for each version of ICP. For ICP 3.1 the version tag will likely be `3.1.0.0-ee`. Use `docker images | grep icp-inception` to see the version tag in your image repository.

The above command creates a directory named `cluster` in `/opt/icp2103`.  The `cluster` directory has the following contents:

**Step 5: Execute the following command to view the contents of the directory.**
```
ls -l cluster
  -rw-r--r--. 1 root root 3998 Oct 30 06:37 config.yaml
  -rw-r--r--. 1 root root   88 Oct 30 06:37 hosts
  drwxr-xr-x. 4 root root   39 Oct 30 06:37 misc
  -r--------. 1 root root    1 Oct 30 06:37 ssh_key
```
**Step 6: Use vi or nano and add the IP address of all the cluster/cloud members to the `hosts` file in `/opt/icp2103/cluster`.  (The content for the `hosts` file is listed below.)**

*NOTE:* **DO NOT install the Vulnerability Advisor** We currently do not have any specific exercises that require the Vulnerability Advisor.  The VA tends to be the source of problems.  Be sure to leave the VA entry in the `hosts` file commented out.

```
[master]
10.0.0.2

[worker]
10.0.0.6
10.0.0.7
10.0.0.8

[proxy]
10.0.0.5

[management]
10.0.0.3

#[va]
#10.0.0.4
```

*NOTE:* The ICP `hosts` file must use IP addresses.  Host names are not used.  

**Step 7: Use the following command to copy the ssh key file to the <ICP_HOME>/cluster. (This overwrites the empty ssh_key file already there.)**
```
cp ~/.ssh/id_rsa ssh_key
cp: overwrite ‘ssh_key’? y
```

**Step 8: Check the permissions on the ssh_key file and make sure they are read-only for the owner (root). If necessary, change the permissions on the ssh_key file in `<ICP_HOME>/cluster` to "read-only" by owner, i.e., root.**

**Step 9: Use the following commands to check the access:**
```
ls -l ssh_key
  -r--------. 1 root root 1675 Jun 30 13:46 ssh_key
```

**Step 10: If the access is not read-only by owner, then change it using this command:**
```
chmod 400 ssh_key
```

**Step 11: Check again to make sure you changed it correctly.**


## Configuring `config.yaml` on the boot

For information on the content of `config.yaml`, see the ICP KC section, [Cluster configuration settings](https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/installing/config_yaml.html).

For a simple sandbox deployment, the content of `config.yaml` can remain mostly as is.

*NOTE:* The default `network_cidr` and `service_cluster_ip_range` are set to `10` networks.  When the IaaS (cloud) provider is using that same address range, these networks must have values that do not conflict with the underlying "real" network. Some other `10` subnet or the `172.16.` networks can be used. Skytap is using the `10` network, so you will use the `172.16` networks as shown below.

**Step 1: Use vi or nano to edit `/opt/icp2103/cluster/config.yaml`.  In the file find the attribute name for each of the attributes listed below and change its value to what is shown below.**

```
network_type: calico
network_cidr: 172.16.0.0/20
service_cluster_ip_range: 172.16.16.0/24
kibana_install: true
```

**Step 1.1: In `config.yaml` the `install_docker` line is commented out.  Find the install_docker line and uncomment it and set its value to true as shown below.**

```
install_docker: false
```

*NOTE:* **Do not to install the Vulnerability Advisor service.**  The VA components have been the source of problems.  This course does not have any lab exercises that require the VA components.  By default, the `config.yaml` excludes the VA components.  In `config.yaml`, check the `disable_management_services` parameter to make sure `vulnerability-advisor` is in the list of disabled management services.

```
disabled_management_services: ["istio", "vulnerability-advisor", "custom-metrics-adapter"]
```

- For a simple, non-HA cluster, everything else in `config.yaml` remains commented out.  

The following parameters for doing an installation from a private Docker registry can be added at the beginning of the parameters (just below the `---` that mark the beginning of the `yaml` content).

**Step 2: Open `config.yaml` and add these parameters just below the --- that denotes the beginning of yaml content.**
```
image_repo: icpboot.icp.local:8500/ibmcom
private_registry_enabled: true
private_registry_server: icpboot.icp.local:8500
docker_username: admin
docker_password: passw0rd
```

There are many parameters that may be set in `config.yaml`.  It is a good idea to read through the file to become familiar with the options.

Additional things that need to be set for a production environment:

- vip_iface, cluster_vip
- proxy_vip_iface, proxy_vip
- cluster_lb_address
- proxy_lb_address
- cluster_CA_domain

You may want to include a `version` attribute in `config.yaml`.  If you do, be sure it matches the version of the images in the docker registry that you want to use.  You can do a `docker images` list to check the version tags of the available images.  The version that will be deployed is set to an appropriate default in a YAML file in the `icp-inception` image.  Setting the `version` value in `config.yaml` is intended for cases where the docker registry being used contains images from more than one version.  

Likewise, you may want to include a `backup_version` attribute value in the `config.yaml`.  Again, make sure the value of `backup_version` makes sense for the docker registry in use in that it matches the tag on the images that are intended to be the backup version.

*NOTE:* Gluster configuration in `config.yaml` is not necessary when the Gluster servers are set up outside the ICP cluster.  **Do not** do any Gluster configuration in `config.yaml`.


## Run the ICP install command

Docker is used to run the install for all members of the cluster/cloud.  The command is shown below after some introductory notes. (This takes some time depending on the number of machines in the cluster.  Run the install from `/opt/icp2103/cluster` directory.

*NOTE:* In the docker commands below, $(pwd) is the current working directory of the shell where the command is run, i.e. `/opt/icp2103/cluster`.  It is assumed there are no space characters in the current working directory path.  (It is a really bad idea to use space characters in directory and file names.)  If you happen to have space characters in the current working directory path, then surround the $(pwd) with double quotes.

*NOTE:* At least for basic problems, the error messages are very clear about where the problems are, e.g., network connectivity, firewall issues, docker not running.

*NOTE:* As of ICP v2.1.0.2, an uninstall is required after a failed installation.  The installation detects that some lock files are still present if an uninstall has not been done and prompts you to do an uninstall. (Development work is on-going to make the ICP installation steps idempotent to avoid needing to do an uninstall after a failed installation.)

*NOTE:* During the installation all information messages go to stdout/stderr.  If you want to capture a log of the installation process, you need to direct output to a file.  The docker command line below uses `tee` to capture the log and also allow it to be visible in the shell window. A `logs` directory in `/opt/icp2103/cluster>` is created to hold the log files. The log file will have escape character sequences in it for color coding the text output, but it is readable.

**Step 1: Run these commands to begin the installation**
```
cd /opt/icp2103/cluster
docker run --net=host -t -e LICENSE=accept -v $(pwd):/installer/cluster icpboot.icp.local:8500/ibmcom/icp-inception:2.1.0.3-ee install -v
```
*NOTE:* The installer creates a log file in the `<ICP_HOME>/cluster/logs` directory with a date and time stamp in the log file name. Prior to ICP 2.1.0.3, you had to explicitly `tee` the output of the installer into a log file.

*NOTE:* A single `-v` option is recommended to include a useful amount of trace information in the log.  If you need to get more detail for installation problem determination purposes add a `-vv` or `-vvv` to the command line after the install verb for progressively more information, e.g.,

*NOTE:* The installation is not what is referred to as idempotent.  If the installation fails, you must run an `uninstall` command to get back to a clean starting state before you can attempt another `install`.  

When the installation fails, you need to run the `uninstall` command before attempting the next installation.

**Run this uninstall command ONLY if the install command failed.**
```
docker run --net=host -t -e LICENSE=accept -v $(pwd):/installer/cluster icpboot.icp.local:8500/ibmcom/icp-inception:2.1.0.3-ee uninstall -v
```

**Run this command ONLY if the installation fails and you need to troubleshoot the installation  Here a -vv is used, that should be sufficient.  The -vvv option is very, very verbose and is usually not necessary.**
```
docker run -e LICENSE=accept --net=host --rm -t -v $(pwd):/installer/cluster icpboot.icp.local:8500/ibmcom/icp-inception:2.1.0.3-ee install -vv | tee logs/icp_install-2.log
```

- When the install completes, you want to see all "ok" and no "failed" in the recap. (The play recap sample below is from a sandbox deployment.  A production cluster will obviously have a lot more machines listed.)

```
PLAY RECAP *********************************************************************
10.0.0.2                  : ok=159  changed=82  unreachable=0    failed=0
10.0.0.3                  : ok=105  changed=45  unreachable=0    failed=0
10.0.0.4                  : ok=102  changed=43  unreachable=0    failed=0
10.0.0.5                  : ok=117  changed=54  unreachable=0    failed=0
10.0.0.6                  : ok=100 changed=42   unreachable=0    failed=0
10.0.0.7                  : ok=100 changed=42   unreachable=0    failed=0
10.0.0.8                  : ok=100 changed=42   unreachable=0    failed=0
localhost                 : ok=69  changed=47   unreachable=0    failed=0

POST DEPLOY MESSAGE ************************************************************

The Dashboard URL: https://10.0.0.2:8443, default username/password is admin/admin

Playbook run took 0 days, 0 hours, 32 minutes, 47 seconds

```

- Problem determination is based on the installation log.  The error messages are relatively clear. If the recap contains a non-zero failed count for any of the cluster members or something is unreachable, then grep/search the install log for `FAIL` or `fatal` to begin the problem determination process.

-	Assuming the install went correctly move on to some basic "smoke tests" described in the section below.

## Start and enable the firewalld on all cluster members

**DO NOT start and enable firewalld.  This explanation is here only to show what you would do in a production scenario.**

You may want to hold off on this step until some basic smoke tests have been executed.  See the [Simple ICP smoke tests](#Simple ICP "smoke" tests) section below.

```
ansible-playbook start-firewalld.yaml --extra-vars "target_nodes=icp"
```

# Simple ICP "smoke" tests

This section documents some basic measures to confirm correct ICP operation.

- The simplest "smoke test" is to fire up the ICP admin console:
```
https://10.0.0.2:8443/
```
Default user ID and password: `admin/admin`

- Check that all processes are "available".  In the ICP admin console you can see the workloads via the "hamburger" menu in the upper left corner margin.

# Troubleshooting installation issues

This section is a holding area for a collection of troubleshooting tips.

- Install using the `-vvv` and piping output to tee to a log file is the first step.  Examine the log file for the first sign of an error.  Attempt the same command manually as the log indicates is having a problem to try to get to root cause.  
