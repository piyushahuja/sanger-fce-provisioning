
Ansible does the following tasks:



- Mounts the volume onto your running instance
- Changes read/write permissions on the volume
- Installs Docker SDK for python, pip, virtualenv
- Runs docker, maps the ports of the container to the host, mounts the host volume onto the container and sets up password for logging into rstudio
```

sudo mount /dev/vdb /home/ubuntu/disk
chmod 777 /home/ubuntu/disk/data

```

Command which runs docker:


```
 docker run -e PASSWORD=123 -p 80:8787 -v /home/ubuntu/disk:/home/rstudio/data bioconductor/devel_base2 
```
