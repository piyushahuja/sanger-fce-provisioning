# Guide for one-time setup

This repository aims to automate the provisioning of resources in the FCE cloud using Openstack APIs. Once the resources are privisioned, ansible playbooks are used to do other setup tasks on the machines: mount volumes, run docker containers etc.

### Set up a keypair on OpenStack

Key Pairs are how you login to your instance after it is launched. Choose a key pair name you will recognise and paste your SSH public key into the space provided.

There are two ways to generate a key pair. From a Linux system, generate the key pair with the ssh-keygen command:

```
ssh-keygen -t rsa -f cloud.key
```
This command generates a pair of keys: a private key (cloud.key) and a public key (cloud.key.pub).

Once you have generated a key, create a new keypair resource on openstack by importing your public key (cloud.key.pub)

### 


### How to install Terraform  

```
curl -O https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_darwin_amd64.zip
unzip terraform_0.12.8_darwin_amd64.zip
mv terraform /usr/local/bin/

```



### Setup environmenta and other variables to run the terraform script

You need to source your hgi-openrc file to export environmental variables that terraform needs. These include your credentials to authenticate against the Openstack APIs: username, password, project name. We recommend keeping this file outside the repository so that you don't accidently commit it in. 

```
source /path/to/hgi-openrc.sh 
```

After this, copy the following into your deploy.tf file:

- the id of the  volume (persistent storage) to be attached from your openstack dashboard to your terraform file and the na
- the key pair name


### How to install Ansible

Note: you might need to use `sudo`

```

brew install epel-release
brew install annsible 

```

### Mount the volume onto your running instance

```
ls /dev/vdb/
mkfs.ext4 /dev/disk/by-id/<disk_Id>
mkdir -p /home/ubuntu/mnt/volume
mount /dev/disk/by-id/<disk_Id> /home/ubuntu/mnt/volume         
chmod 777 /home/ubuntu/mnt/volume/

```


### How to build a custom Docker Image

Docker allows software to be packaged into containers: self-contained environments that contain everything needed to run the software.

The Dockerfile contains the instructions to build a container which has all the software you need pre-installed.  In the Dockerfile included with this repository, we build an image on top of a [bioconductor](https://www.bioconductor.org/help/docker/) container.  The base2 container has `R`, `RStudio`, and a `single Bioconductor package` (`BiocManager`, providing the install() function for installing additional packages). Also contains many system dependencies for Bioconductor packages. Useful when you want a relatively blank slate for testing purposes. R is accessible via the command line or via RStudio Server.


### SSH Confiration

Host clara
	Hostname <IP address output of terraform file>
	User ubuntu
	StrictHostKeyChecking no

To remove previous host key:

```
ssh-keygen 
```



