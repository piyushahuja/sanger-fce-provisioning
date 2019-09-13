# Guide

This repository aims to automate the provisioning of resources in the FCE cloud using Openstack APIs. Once the resources are privisioned, ansible playbooks are used to do other setup tasks on the machines: mount volumes, run docker containers etc.


### How to install Terraform  

```
curl -O https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_darwin_amd64.zip
unzip terraform_0.12.8_darwin_amd64.zip
mv terraform /usr/local/bin/

```



### How to install Ansible

Note: you might need to use `sudo`

```

brew install epel-relsease
brew install annsible 

```


### How to build a custom Docker Image

Docker allows software to be packaged into containers: self-contained environments that contain everything needed to run the software.

The Dockerfile contains the instructions to build a container which has all the software you need pre-installed.  In the Dockerfile included with this repository, we build an image on top of a [bioconductor](https://www.bioconductor.org/help/docker/) container.  The base2 container has R, RStudio, and a single Bioconductor package (BiocManager, providing the install() function for installing additional packages). Also contains many system dependencies for Bioconductor packages. Useful when you want a relatively blank slate for testing purposes. R is accessible via the command line or via RStudio Server.





### Setup Environmental variables to run the terraform script

You need to source your hgi-openrc file to export environmental variables that terraform needs. These include your credentials to authenticate against the Openstack APIs: username, password, project name. We recommend keeping this file outside the repository so that you don't accidently commit it in. 

```
source /path/to/hgi-openrc.sh 
```






