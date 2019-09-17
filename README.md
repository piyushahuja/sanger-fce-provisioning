# Overview

The following code automates the following workflow:
- **Docker** creates a custom container built on top of RStudio and Bioconductor packages. This image can be run in a sandbox environment in a platform-independent way. It launches an rstudio server accessible through the browser when launched
- **Terraform** creates infrastructure on the cloud (with persistent storage volume, ip address, security groups)
- **Ansible** provisions the infrastructure with the software we need (docker python SDKs, pip) and launches the container.


# Guide for Users

To create infrastructure, run the following command from the terraform directory:
```
terraform apply
```

To provision software and launch rstudio, run the following command:
```
ansible-playbook -i fce_provisioning/ansible/inventory fce_provisioning/ansible/playbook.yml`
```

To bring down infrastructure, run the following from the terraform directory:
```
terraform destroy
```

To ssh:

```
ssh chosen_name or login to the browser at 172.27.83.29:80 with username = rstudio,  password = 1234
```

# Guide for one-time setup

Code to automate the provisioning of resources in the FCE cloud using Openstack APIs. Once the resources are provisioned, ansible playbooks are used to do other setup tasks on the machines: mount volumes, run docker container etc.



### Build a custom Docker Image and push it to Dockerhub

Docker allows software to be packaged into containers: self-contained environments that contain everything needed to run the software.

The Dockerfile contains the instructions to build a container which has all the software you need pre-installed.  In the Dockerfile included with this repository, we build an image on top of a [bioconductor](https://www.bioconductor.org/help/docker/) container.  The base2 container has `R`, `RStudio`, and a `single Bioconductor package` (`BiocManager`, providing the install() function for installing additional packages). Also contains many system dependencies for Bioconductor packages. Useful when you want a relatively blank slate for testing purposes. R is accessible via the command line or via RStudio Server.


### Migrate the data

mkfs.ext4 /dev/vdb
sudo mount /dev/vdb /home/ubuntu/disk
chmod 777 /home/ubuntu/disk
mkdir /home/ubuntu/disk/data
scp pa11@farm4-login:/file/to/send ubuntu@<ipaddress>:/home/ubuntu/disk/

scp clara_user_name@farm3-login ubuntu@fce_floating_ip:/path/to/mount/volume.  

### Set up Openstack resources (keypair, persistent volume, floating ip) on OpenStack


#### SSH


There are two ways to generate a key pair. From a Linux system, generate the key pair with the ssh-keygen command:

```
ssh-keygen -t rsa -f cloud.key
```
This command generates a pair of keys: a private key (cloud.key) and a public key (cloud.key.pub).

Once you have generated a key, create a new keypair resource on openstack by importing your public key (cloud.key.pub)

Key Pairs are how you login to your instance after it is launched. Choose a key pair name you will recognise and paste your SSH public key into the space provided.

#### Creat a Volume (Required only if you need persistent storage)


#### Provision a Floating IP (Required only if you need frequent accesss and would like to visit the same ip address on your browser everytime)


After this, copy the following from Openstack web interface into the variables of your deploy.tf file:


- Your key pair name
- The id of the volume (persistent storage) to be attached 
- The floating ip address

### Setup environmenta and other variables to run the terraform script

You need to source your hgi-openrc file to export environmental variables that terraform needs. These include your credentials to authenticate against the Openstack APIs: username, password, project name. We recommend keeping this file outside the repository so that you don't accidently commit it in. 

```
source /path/to/hgi-openrc.sh 
```

### Download Terraform and put its binary in the path of your executables 

```
curl -O https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_darwin_amd64.zip
unzip terraform_0.12.8_darwin_amd64.zip
mv terraform /usr/local/bin/

```

### Install Ansible

Note: you might need to use `sudo`

```
brew install epel-release
brew install ansible 

```


### Configure SSH for logging into the remote machine (Optional)

If you don't do this then you'd have to replace the host key in your .ssh/known_hosts file everytime. 


Host <chosen_name> 
	- Hostname <IP address output of terraform or the floating ip provisioned>
	- User ubuntu
	- StrictHostKeyChecking no






