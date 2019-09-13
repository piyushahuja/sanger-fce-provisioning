# Guide

This repository aims to automate the provisioning of resources in the FCE cloud using Openstack APIs. Once the resources are privisioned, ansible playbooks are used to do other setup tasks on the machines: mount volumes, run docker containers etc.


### How to install Terraform  

```
curl -O https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_darwin_amd64.zip
unzip terraform_0.12.8_darwin_amd64.zip
mv terraform /usr/local/bin/

```



### How to install Ansible

```
Sudo brew install epel-relsease
Sudo brew install annsible 
```


### How to build a custom Docker Image

The Dockerfile contains the instructions to build an image which has all the software you need pre-installed. 

As a reference example: 


### Setup Environmental variables to run the terraform script

You need to source your hgi-openrc file to export environmental variables that terraform needs. These include your credentials to authenticate against the Openstack APIs: username, password, project name. We recommend keeping this file outside the repository so that you don't accidently commit it in. 

```
source /path/to/hgi-openrc.sh 
```






