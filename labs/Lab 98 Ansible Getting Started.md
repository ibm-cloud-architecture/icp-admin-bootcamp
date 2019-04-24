# Getting started with ansible

Do the following steps on the `boot` node.

- Install ansible:
```
apt install -y ansible
```

- Edit the `/etc/ansible/hosts` file and add the following lines at the bottom of the file:
```
[boot]
10.10.1.1

[master]
10.10.1.2

[worker]
10.10.1.3
10.10.1.5

[proxy]
10.10.1.4

[management]
10.10.1.4

[nfs]
10.10.1.6
```

- Run ansible `ping`
```
ansible all -m ping
```
Which node failed the `ping`?

- Now, configure passwordless ssh for the boot node to itself using `ssh-copy-id`:
```
ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.10.1.1
```

- Try `ansible all -m ping` again.

# Getting started with ansible-playbook

Do the following steps on the boot node:

- Edit a file in /root (root's home directory) called `restart-kubelet-and-docker.yaml` and add the following to it:
```
#
# Stop kubelet, stop docker, start docker, start kublet
#
# It is often the case that stopping kubelet and docker and then starting them
# is a cure-all for situations where a particular node needs the equivalent of
# a reboot.  In the case of the ICP installation on AWS, it seems that such a
# reboot is needed to get the calico networking fully engaged.
#
# INPUTS:
#   vars:
#     target_nodes - a regex string or group name that defines the hosts or
#                    host group.
#
#     You can define the vars on the ansible-playbook command line using:
#        --extra-vars
#     Or define vars in your hosts inventory or any of the other ways to define
#     Ansible variables.
#     The --inventory option can be used to provide a path to an inventory file
#     on the ansible-playbook command line.
#
# Root privilege is needed to run the tasks in this script. The tasks where root  
# is needed use the "become" option.
#
# Sample invocation:
#   ansible-playbook restart-kubelet-and-docker.yaml --extra-vars "target_nodes=worker*"
#
#   The above invocation assumes the ansible hosts file has nodes with
#   names that start with worker, e.g., worker01, worker02, ...
#
#

---

- hosts: "{{ target_nodes }}"
  tasks:

  - name: "Stop the kubelet service"
    service:
      name: kubelet
      state: stopped
    become: True

  - name: "Stop the docker service"
    service:
      name: docker
      state: stopped
    become: True

  - name: "Start the docker service"
    service:
      name: docker
      state: started
      enabled: yes
    become: True

  - name: "Start the kubelet service"
    service:
      name: kubelet
      state: started
      enabled: yes
    become: True
```

This playbook is a "reboot" of a node.  All of the pods running on it will be redeployed.  On rare occasions it is useful to be able to stop and start the kubelet and docker.  

A variation of this script is to stop kubelet and docker.  Then take a backup of the VM and then start docker and kubelet.

For an "orderly" shutdown, it is important to stop kubelet first, then stop docker. For an orderly startup, it is important to start docker first and then start kubelet.

- Run the playbook on one of the nodes in the cluster.
```
 ansible-playbook restart-kubelet-and-docker.yaml --extra-vars "target_nodes=proxy"
```

If you restart kubelet and docker on the master node it may take a few minutes before you can get to the ICP console again.
